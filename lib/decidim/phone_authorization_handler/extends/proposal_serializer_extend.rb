# frozen_string_literal: true

module Decidim::PhoneAuthorizationHandler
  module Extends
    module ProposalSerializerExtend
      # Public: Initializes the serializer with a proposal.
      # public_scope : Bool (default: true) - Allow to add extra information when administrator exports
      def initialize(proposal, public_scope = true)
        @proposal = proposal
        @public_scope = public_scope
      end

      # Public: Exports a hash with the serialized data for this proposal.
      def serialize
        {
          id: proposal.id,
          category: {
            id: proposal.category.try(:id),
            name: proposal.category.try(:name) || empty_translatable
          },
          scope: {
            id: proposal.scope.try(:id),
            name: proposal.scope.try(:name) || empty_translatable
          },
          participatory_space: {
            id: proposal.participatory_space.id,
            url: Decidim::ResourceLocatorPresenter.new(proposal.participatory_space).url
          },
          component: { id: component.id },
          title: proposal.title,
          body: proposal.body,
          address: proposal.address,
          state: proposal.state.to_s,
          reference: proposal.reference,
          answer: ensure_translatable(proposal.answer),
          supports: proposal.proposal_votes_count,
          endorsements: {
            total_count: proposal.endorsements.count,
            user_endorsements: user_endorsements
          },
          comments: proposal.comments_count,
          attachments: proposal.attachments.count,
          followers: proposal.followers.count,
          published_at: proposal.published_at,
          url: url,
          meeting_urls: meetings,
          related_proposals: related_proposals,
          is_amend: proposal.emendation?,
          original_proposal: {
            title: proposal&.amendable&.title,
            url: original_proposal_url
          }
        }.merge(options_merge(author: author_metadata))
      end

      # options_merge allows to add some objects to merge to the serialize
      # Params : options_object : Hash
      # Return Hash
      def options_merge(options_object)
        @public_scope ? {} : options_object
      end

      # author_metadata allows to retrieve user name, nickname and phone_number from the phone_authorization_handler
      # Return an empty object if decidim_author_type is different than Decidim::UserBaseEntity
      def author_metadata
        author_metadata = {
          name: "",
          nickname: "",
          email: "",
          phone_number: ""
        }
        if proposal.creator.decidim_author_type == "Decidim::UserBaseEntity"
          begin
            user = Decidim::User.find proposal.creator_author.id
          rescue ActiveRecord::RecordNotFound
            user = Decidim::UserGroup.find proposal.creator_author.id
          end

          author_metadata[:name] = user.try(:name).presence || ""
          author_metadata[:nickname] = user.try(:nickname).presence || ""
          author_metadata[:email] = user.try(:email).presence || ""
          author_metadata[:phone_number] = phone_number user.id
        end

        author_metadata
      end

      # phone_number retrieve the phone number of an user stored from phone_authorization_handler
      # Param: user_id : Integer
      # Return string, empty or with the phone number
      def phone_number(user_id)
        authorization = Decidim::Authorization.where(name: "phone_authorization_handler", decidim_user_id: user_id)
        return "" if authorization.blank?

        metadata = authorization.first.try(:metadata)
        return "" if metadata.blank?

        # rubocop:disable Lint/SafeNavigationChain
        authorization.first.try(:metadata)&.to_h["phone_number"].presence || ""
        # rubocop:enable Lint/SafeNavigationChain
      end
    end
  end
end
