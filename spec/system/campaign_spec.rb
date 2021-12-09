# frozen_string_literal: true

require "spec_helper"
require "decidim/social_crowdfunding/test/shared_contexts"

describe "Show campaign", type: :system do
  include_context "with a component"
  include_context "with stubs example api"

  let(:manifest_name) { "social_crowdfunding_campaign" }

  let(:campaign_slug) { "nodo-movil" }

  let!(:data) { JSON.parse(file_fixture("goteo-project.json").read) }

  let(:settings) do
    {
      campaign_id: campaign_slug
    }
  end

  before do
    component.settings = settings
    component.save!

    visit_component
  end

  it "displays campaign media embed" do
    within ".responsive-embed" do
      expect(page).to have_selector("iframe")
    end
  end

  it "displays campaign thermometer" do
    expect(page).to have_selector(".thermometer-container")

    within ".thermometer-info" do
      within ".campaign__date" do
        expect(page).to have_content("13/05/2011")
      end
      within ".reached" do
        expect(page).to have_content("€1,744")
      end
      within ".optimum" do
        expect(page).to have_content("€1,750")
      end
      within ".minimum" do
        expect(page).to have_content("€1,250")
      end
    end
  end

  it "displays campaign status" do
    within ".campaign__status" do
      expect(page).to have_content("Accomplished!")
      expect(page).to have_link("VISIT CAMPAIGN")
    end
  end

  it "displays description" do
    expect(page).to have_selector(".section-heading + #costs", visible: :hidden)
    expect(page).to have_selector(".section-heading + #description-general", visible: :all)
    expect(page).to have_selector(".section-heading + #description-about", visible: :hidden)
    expect(page).to have_selector(".section-heading + #description-motivation", visible: :hidden)
    expect(page).to have_selector(".section-heading + #description-goal", visible: :hidden)
  end
end
