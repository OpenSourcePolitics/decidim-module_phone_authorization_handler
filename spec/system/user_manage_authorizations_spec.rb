# frozen_string_literal: true

require "spec_helper"

describe "User authorizations", type: :system do
  include Decidim::TranslatableAttributes

  let!(:scope) { create_list(:scope, 3, organization: organization) }
  let!(:organization) do
    create(:organization,
           available_authorizations: ["phone_authorization_handler"])
  end

  let(:user) { create(:user) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim.root_path
    click_link user.name
    click_link "Authorizations"
  end

  it "displays the authorization item" do
    within ".tabs-content.vertical" do
      expect(page).to have_content("Phone Authorization Handler")
    end
  end

  context "when accessing authorization" do
    before do
      visit "/authorizations"

      click_link "Phone Authorization Handler"
    end

    it "displays authorization form" do
      expect(page).to have_content "Phone Authorization Handler"

      within ".new_authorization_handler" do
        expect(page).to have_field("Phone number")
      end
    end

    it "allows user to fill form" do
      fill_in "Phone number", with: "0666666666"
      click_button "Send"

      expect(page).to have_content("You've been successfully authorized")
    end

  end
end
