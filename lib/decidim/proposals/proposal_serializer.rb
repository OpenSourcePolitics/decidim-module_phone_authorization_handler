# frozen_string_literal: true

module Decidim
  module Proposals
    # This class serializes a Proposal so can be exported to CSV, JSON or other
    # formats.
    class ProposalSerializer < Decidim::Exporters::Serializer
      include Decidim::ApplicationHelper
      include Decidim::ResourceHelper
      include Decidim::TranslationsHelper

      # Public: Initializes the serializer with a proposal.
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
          collaborative_draft_origin: proposal.collaborative_draft_origin,
          component: { id: component.id },
          title: present(proposal).title,
          body: present(proposal).body,
          state: proposal.state.to_s,
          reference: proposal.reference,
          answer: ensure_translatable(proposal.answer),
          supports: proposal.proposal_votes_count,
          endorsements: proposal.endorsements.count,
          comments: proposal.comments.count,
          amendments: proposal.amendments.count,
          attachments_url: attachments_url,
          attachments: proposal.attachments.count,
          followers: proposal.followers.count,
          published_at: proposal.published_at,
          url: url,
          meeting_urls: meetings,
          related_proposals: related_proposals
        }.merge(options_merge(author: author_metadata))
      end

      private

      attr_reader :proposal

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
          user = Decidim::User.find proposal.creator_author.id

          author_metadata[:name] = user.try(:name)
          author_metadata[:nickname] = user.try(:nickname)
          author_metadata[:email] = user.try(:email)
          author_metadata[:phone_number] = phone_number user.id
        end

        author_metadata
      end

      # phone_number retrieve the phone number of an user stored from phone_authorization_handler
      # Param: user_id : Integer
      # Return string, empty or with the phone number
      def phone_number(user_id)
        authorization = Decidim::Authorization.where(name: "phone_authorization_handler", decidim_user_id: user_id)
        result = ""

        unless authorization.empty?
          result = authorization.first.try(:metadata).to_h["phone_number"] unless authorization.first.try(:metadata).nil?
        end

        result.presence || ""
      end

      def component
        proposal.component
      end

      def meetings
        proposal.linked_resources(:meetings, "proposals_from_meeting").map do |meeting|
          Decidim::ResourceLocatorPresenter.new(meeting).url
        end
      end

      def related_proposals
        proposal.linked_resources(:proposals, "copied_from_component").map do |proposal|
          Decidim::ResourceLocatorPresenter.new(proposal).url
        end
      end

      def url
        Decidim::ResourceLocatorPresenter.new(proposal).url
      end

      def attachments_url
        proposal.attachments.map { |attachment| proposal.organization.host + attachment.url }
      end
    end
  end
end
