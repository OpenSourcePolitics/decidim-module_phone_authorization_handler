# frozen_string_literal: true

require "spec_helper"

describe "Phone authorization handler form", type: :system do
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
      expect(page).to have_content("Phone number recovery")
    end
  end

  context "when accessing authorization" do
    before do
      visit "/authorizations"

      click_link "Phone number recovery"
    end

    it "displays authorization form" do
      expect(page).to have_content "Fill in your phone number"
      expect(page).to have_content "The City of Angers may also seek to contact you with the email address you use on this platform. This personal information is reserved for the platform's administrators and is not accessible to other users."

      within ".new_authorization_handler" do
        expect(page).to have_field("Phone number (without point nor whitespace)")
      end
    end

    it "allows user to fill form" do
      fill_in "Phone number (without point nor whitespace)", with: "0666666666"
      click_button "I continue"

      expect(page).to have_content("You've been successfully authorized")
    end

    it "shows error message for too short phone number" do
      fill_in "Phone number (without point nor whitespace)", with: "066666666"
      click_button "I continue"

      expect(page).to have_content("There's an error in this field")
    end

    it "shows error message for too long phone number" do
      fill_in "Phone number (without point nor whitespace)", with: "06666666666666"
      click_button "I continue"

      expect(page).to have_content("Not a valid phone number format")
    end

    it "shows error message for not numeric phone number" do
      fill_in "Phone number (without point nor whitespace)", with: "NOT_A_VALID_FORMAT"
      click_button "I continue"

      expect(page).to have_content("Not a valid phone number format")
    end

    it "shows error message for invalid phone number format" do
      fill_in "Phone number (without point nor whitespace)", with: "3344444444"
      click_button "I continue"

      expect(page).to have_content("Not a valid phone number format")
    end
  end
end
