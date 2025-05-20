# frozen_string_literal: true

require "spec_helper"
require "decidim/social_crowdfunding/test/shared_contexts"

describe "Visit the admin page" do
  include_context "with stubs example api"
  include_context "with finished campaign component"

  let!(:campaign) { create(:campaign) }
  let!(:campaign_name) { "Nodo Móvil" }
  let!(:campaign_slug) { "nodo-movil" }

  let!(:organization) { create(:organization) }
  let!(:admin) { create(:user, :admin, :confirmed, organization:) }

  let!(:edit_component_path) { Decidim::EngineRouter.admin_proxy(component.participatory_space).edit_component_path(component.id) }

  before do
    switch_to_host(organization.host)
    login_as admin, scope: :user

    visit manage_component_path(component)
  end

  it "has a button to manage the component" do
    expect(page).to have_link("Manage settings", href: edit_component_path)
  end

  it "has a button to create a campaign in goteo" do
    expect(page).to have_link("Create campaign", href: Decidim::SocialCrowdfunding::Goteo.create_campaign_url)
  end

  context "when there isn't a valid Goteo configuration setted for the component" do
    it "displays an alert requesting to create a Goteo configuration" do
      expect(page).to have_content("Please create a valid Goteo configuration")
    end
  end

  context "when creating a new Goteo configuration" do
    let!(:email) { "user@example.org" }
    let!(:password) { "123456" }
    let!(:valid_token_data) { JSON.parse(file_fixture("goteo-valid-token.json").read) }
    let!(:invalid_token_data) { JSON.parse(file_fixture("goteo-invalid-token.json").read) }

    before do
      click_on "Manage Goteo configurations"
    end

    it "allows to create a new configuration if the email and password introduced are correct" do
      stub_request(:post, "#{api_url}/user_tokens")
        .to_return(status: 200, body: valid_token_data.to_json, headers: {})

      click_on "Create Goteo configuration"

      fill_in "Goteo email", with: email
      fill_in "Goteo password", with: password

      click_on "Create configuration"

      expect(page).to have_content("Your Goteo configuration has been created successfully")
      within ".table-list" do
        expect(page).to have_content(email)
      end
    end

    it "doesn't create a new configuration and displays an alert if the email or password introduced are incorrect" do
      stub_request(:post, "#{api_url}/user_tokens")
        .to_return(status: 404, body: invalid_token_data.to_json, headers: {})

      click_on "Create Goteo configuration"

      fill_in "Goteo email", with: "user@example.m"
      fill_in "Goteo password", with: password

      click_on "Create configuration"

      expect(page).to have_content("There was a problem creating your Goteo configuration. Please check your email and password and try again")
      expect(page).to have_content("Create Goteo configuration")
    end
  end

  context "when deleting a Goteo configuration" do
    let!(:goteo_configuration) { create(:goteo_configuration, organization:) }

    before do
      click_on "Manage Goteo configurations"
    end

    it "allows to delete an existing configuration" do
      within ".table-list__actions" do
        click_on "Delete"
      end

      click_on "OK"
      expect(page).to have_content("Your Goteo configuration has been deleted")
    end
  end

  context "when there is a valid Goteo configuration setted for the component" do
    let!(:goteo_configuration) { create(:goteo_configuration, organization:) }

    before do
      component.settings = { "goteo_configuration_id": goteo_configuration.id, "campaign_slug": campaign_slug }
      component.save!
      visit manage_component_path(component)
    end

    it "doesn't display an alert requesting to create a Goteo configuration" do
      visit manage_component_path(component)
      expect(page).to have_no_content("Please create a valid Goteo configuration")
    end

    it "allows selecting a different campaign" do
      expect(page).to have_content("Select a campaign")

      within "form.new_select_campaign" do
        within "label" do
          expect(page).to have_field("select_campaign[slug]")
        end
        expect(page).to have_button("Update campaign")
      end
    end

    it "shows stored campaigns" do
      expect(page).to have_content("Stored campaigns")

      within ".table-scroll tbody tr" do
        within "td:nth-child(2)" do
          expect(page).to have_content(campaign.data["title"])
        end
      end
    end

    it "allows deleting a campaign" do
      within ".table-list__actions" do
        click_on "Delete"
      end

      click_on "OK"
      expect(page).to have_content("The campaign has been deleted")
    end
  end
end
