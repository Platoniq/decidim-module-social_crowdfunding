# frozen_string_literal: true

require "spec_helper"
require "decidim/social_crowdfunding/test/shared_contexts"

describe "Visit the admin page", type: :system do
  include_context "with stubs example api"
  include_context "with campaign component"

  let(:campaign_name) { "Nodo Móvil" }
  let(:campaign_slug) { "nodo-movil" }

  let(:organization) { create :organization }
  let!(:admin) { create(:user, :admin, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as admin, scope: :user

    visit manage_component_path(component)
  end

  it "has a button to create a campaign in goteo" do
    expect(page).to have_link("Create campaign")
  end

  it "shows the selected campaign" do
    expect(page).to have_content("Selected campaign")
    expect(page).to have_link(campaign_name)
  end

  it "allows selecting a different campaign" do
    expect(page).to have_content("Select a campaign")

    within "form.new_select_campaign" do
      expect(page).to have_selector("input#select_campaign_slug")
      expect(page).to have_button("Update campaign")
    end
  end

  it "shows stored campaigns" do
    expect(page).to have_content("Stored campaigns")

    within ".table-scroll tbody tr" do
      within "td:nth-child(1)" do
        expect(page).to have_link(campaign_slug)
      end
    end
  end
end
