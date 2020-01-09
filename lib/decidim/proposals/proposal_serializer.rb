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
        data = {
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
        }

        # TODO: IDE says @public_scope is a Hash but it shouldn't

        data[:author] = author_metadata

        data
      end

      private

      attr_reader :proposal

      def author_metadata
        author_metadata = {
          name: "",
          nickname: "",
          phone_number: ""
        }
        if proposal.creator.decidim_author_type == "Decidim::UserBaseEntity"
          user = Decidim::User.find proposal.creator_author.id
          author_metadata[:name] = user.try(:name)
          author_metadata[:nickname] = user.try(:nickname)
          #author_metadata[:phone_number] = phone_number user.id
        end

        author_metadata
      end

      def phone_number(user_id)
        authorization = Decidim::Authorization.where(name: "phone_authorization_handler", decidim_user_id: user_id)
        authorization.try(:metadata)[:phone_number].to_i
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
