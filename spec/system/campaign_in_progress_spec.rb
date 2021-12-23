# frozen_string_literal: true

require "spec_helper"
require "decidim/social_crowdfunding/test/shared_contexts"

describe "Show campaign", type: :system do
  include_context "with stubs example api"
  include_context "with in progress campaign component"

  it "displays campaign media embed" do
    within ".responsive-embed" do
      expect(page).to have_selector("iframe")
    end
  end

  it "displays campaign thermometer" do
    expect(page).to have_selector(".thermometer-container")

    within ".thermometer-info" do
      expect(page).to have_content("Second round")

      within ".reached" do
        expect(page).to have_content("€126,563")
      end
      within ".optimum" do
        expect(page).to have_content("€130,111")
      end
      within ".minimum" do
        expect(page).to have_content("€94,185")
      end
    end

    within ".thermometer-container .percentage" do
      expect(page).to have_content("134%")
    end
  end

  context "when more than 1 day left" do
    before do
      Timecop.freeze(Date.parse(data["date-published"]) + 55.days)
      visit_component
    end

    it "displays the hours left" do
      within ".thermometer-info .date" do
        expect(page).to have_content("10 days")
      end
    end
  end

  context "when less than 1 day left" do
    before do
      Timecop.freeze(Date.parse(data["date-published"]) + 64.days)
      visit_component
    end

    it "displays the hours left" do
      within ".thermometer-info .date" do
        expect(page).to have_content("Only 23 hours!")
      end
    end
  end

  it "shows a link with the Goteo logo" do
    within ".button--goteo" do
      expect(page).to have_content("DONATE IN")
      expect(page).to have_selector("img.goteo-logo")
    end
  end

  it "displays campaign status" do
    within ".campaign__status" do
      expect(page).to have_content("In campaign")
    end
  end

  it "displays project description sections" do
    expect(page).to have_selector(".section-heading + #costs", visible: :hidden)
    expect(page).to have_selector(".section-heading + #description-general", visible: :all)
    expect(page).to have_selector(".section-heading + #description-about", visible: :hidden)
    expect(page).to have_selector(".section-heading + #description-motivation", visible: :hidden)
  end

  it "does not display goal section (because project doesn't have it)" do
    expect(page).not_to have_selector(".section-heading + #description-goal", visible: :hidden)
  end

  it "does not display social commitment section (because project doesn't have it)" do
    expect(page).not_to have_selector(".section-heading + #social-commitment", visible: :hidden)
  end

  it "shows a list of rewards" do
    expect(page).to have_link "See all rewards"

    within "#rewards .card-grid .column:first-of-type" do
      within ".card__content" do
        within ".card__header" do
          expect(page).to have_content "Contributing €10"
          expect(page).to have_content "Amadrina una Teya"
        end

        within ".card__text" do
          expect(page).to have_content "Por sólo 10€ amadrinarás una teja de La Benéfica: patrocinas el derribo y construccion del tejado"
        end
      end

      within ".card__icondata:nth-child(2)" do
        expect(page).to have_selector "svg.icon--info.icon"
        expect(page).to have_content "AMADRINA UNA TEYA"
      end

      within ".card__icondata:nth-child(3)" do
        expect(page).to have_selector "svg.icon--tag.icon"
        expect(page).to have_content "CONTRIBUTING €10"
      end

      within ".card__footer" do
        within ".backers" do
          expect(page).to have_content("263 backers")
        end
      end
    end
  end
end
