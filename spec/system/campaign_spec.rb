# frozen_string_literal: true

require "spec_helper"
require "decidim/social_crowdfunding/test/shared_contexts"

describe "Show campaign", type: :system do
  include_context "with stubs example api"
  include_context "with campaign component"

  it "displays campaign media embed" do
    within ".responsive-embed" do
      expect(page).to have_selector("iframe")
    end
  end

  it "displays campaign thermometer" do
    expect(page).to have_selector(".thermometer-container")

    within ".thermometer-info" do
      within ".date" do
        expect(page).to have_content("23/01/2012")
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
    expect(page).to have_link("Visit")

    within ".campaign__status" do
      expect(page).to have_content("Accomplished!")
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
