# frozen_string_literal: true

require "spec_helper"
require "decidim/social_crowdfunding/test/shared_contexts"

describe "Visit the admin page" do
  include_context "with stubs example api"
  include_context "with finished campaign component"

  let(:campaign) { create(:campaign) }
  let(:campaign_name) { "Nodo Móvil" }
  let(:campaign_slug) { "nodo-movil" }

  let(:organization) { create(:organization) }
  let!(:admin) { create(:user, :admin, :confirmed, organization:) }

  let(:edit_component_path) { Decidim::EngineRouter.admin_proxy(component.participatory_space).edit_component_path(component.id) }

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

  it "shows the selected campaign" do
    expect(page).to have_content("Selected campaign")
    expect(page).to have_link(campaign_name, href: campaign.url)
  end

  it "allows selecting a different campaign" do
    expect(page).to have_content("Select a campaign")

    within "form.new_select_campaign" do
      expect(page).to have_field("input#select_campaign_slug")
      expect(page).to have_button("Update campaign")
    end
  end

  it "shows stored campaigns" do
    expect(page).to have_content("Stored campaigns")

    within ".table-scroll tbody tr" do
      within "td:nth-child(1)" do
        expect(page).to have_link(campaign_slug, href: campaign.url)
      end
    end
  end
end
