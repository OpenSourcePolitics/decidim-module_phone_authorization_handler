# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/participatory_processes/test/factories"
require "decidim/meetings/test/factories"
require "decidim/proposals/test/factories"


FactoryBot.define do
  factory :phone_authorization_handler_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :phone_authorization_handler).i18n_name }
    manifest_name :phone_authorization_handler
    participatory_space { create(:participatory_process, :with_steps) }
  end

  factory :admin, class: "Decidim::System::Admin" do
    sequence(:email) { |n| "admin#{n}@citizen.corp" }
    password { "password1234" }
    password_confirmation { "password1234" }
  end

end

FactoryBot.modify do
  factory :proposal, class: "Decidim::Proposals::Proposal" do

      after(:build) do |proposal, evaluator|
        if proposal.component
          users = evaluator.users || [create(:user, organization: proposal.component.participatory_space.organization)]
          users.each_with_index do |user, idx|
            user_group = evaluator.user_groups[idx]
            proposal.coauthorships.build(author: user, user_group: user_group)
          end
        end
      end

      trait :author do
          after :build do |proposal|
              {
                name: proposal.creator_author.name,
                nickname: proposal.creator_author.nickname,
                phone_number: Decidim::Authorization.find.where(decidim_user_id: proposal.creator_author)
              }
            end
        end
    end
end
