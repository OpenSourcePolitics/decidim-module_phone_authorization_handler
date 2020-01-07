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
