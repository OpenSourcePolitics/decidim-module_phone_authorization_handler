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
      expect(page).to have_content "Phone number recovery"
      expect(page).to have_content I18n.t("phone_authorization.form.email_recuperation_message")

      within ".new_authorization_handler" do
        expect(page).to have_field("Phone number")
      end
    end

    it "allows user to fill form" do
      fill_in "Phone number", with: "0666666666"
      click_button "Send"

      expect(page).to have_content("You've been successfully authorized")
    end

    it "shows error message for to short phone number" do
      fill_in "Phone number", with: "066666666"
      click_button "Send"

      expect(page).to have_content("There's an error in this field")
    end

    it "shows error message for to long phone number" do
      fill_in "Phone number", with: "06666666666666"
      click_button "Send"

      expect(page).to have_content("Not a valid phone number format")
    end

    it "shows error message for not numeric phone number" do
      fill_in "Phone number", with: "NOT_A_VALID_FORMAT"
      click_button "Send"

      expect(page).to have_content("Not a valid phone number format")
    end

    it "shows error message for invalid phone number format" do
      fill_in "Phone number", with: "3344444444"
      click_button "Send"

      expect(page).to have_content("Not a valid phone number format")
    end
  end

  context "when create new proposal" do
    include_context "with a component"

    let!(:participatory_processes) { create_list(:participatory_process, 5, :with_steps, organization: organization) }
    let!(:component) { create(:proposal_component, :with_creation_enabled, participatory_space: participatory_processes.first) }

    before do
      permissions = {
        create: {
          authorization_handlers: {
            "phone_authorization_handler" => { "options" => {} }
          }
        }
      }

      component.update!(permissions: permissions)

      visit main_component_path(component)
    end

    it "authorizationModal should appear on new proposal click link" do
      expect(page).to have_content(find("a", text: "New proposal").text)
      click_link find("a", text: "New proposal").text
      expect(page).to have_content("Phone number recovery")
    end

    it "adds the redirect_url defined to the authorization path" do
      click_link find("a", text: "New proposal").text

      redirect_url = find("a", text: "New proposal")["data-redirect-url"]
      within "#authorizationModal" do
        expect(page).to have_css("a.button.expanded")
        href = find(".button.expanded")[:href]
        expect(href).to include("&redirect_url=#{redirect_url.gsub(%r{/}, "%2F")}")
      end
    end

    it "adds a redirect_url to the authorization form" do
      click_link find("a", text: "New proposal").text
      redirect_url = find("a", text: "New proposal")["data-redirect-url"]

      within "#authorizationModal" do
        click_link find("a", text: "Authorize with \"Phone number recovery\"").text
      end

      fill_in "Phone number", with: "0655555555"
      within ".new_authorization_handler" do
        find("*[type=\"submit\"]").click
      end

      expect(page).to have_current_path(redirect_url)
    end
  end
end
