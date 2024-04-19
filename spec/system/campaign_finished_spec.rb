# frozen_string_literal: true

require "spec_helper"
require "decidim/social_crowdfunding/test/shared_contexts"

describe "Show campaign" do
  include_context "with stubs example api"
  include_context "with finished campaign component"

  it "displays campaign media embed" do
    within ".responsive-embed" do
      expect(page).to have_css("iframe")
    end
  end

  it "displays campaign thermometer" do
    expect(page).to have_css(".thermometer-container")

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

    within ".thermometer-container .percentage" do
      expect(page).to have_content("139%")
    end
  end

  it "shows a link with the Goteo logo" do
    within ".button--goteo" do
      expect(page).to have_content("VISIT IN")
      expect(page).to have_css(".goteo-logo")
    end
  end

  it "displays campaign status" do
    within ".campaign__status" do
      expect(page).to have_content("Accomplished!")
    end
  end

  it "displays project description sections" do
    expect(page).to have_css(".section-heading + #costs", visible: :hidden)
    expect(page).to have_css(".section-heading + #description-general", visible: :all)
    expect(page).to have_css(".section-heading + #description-about", visible: :hidden)
    expect(page).to have_css(".section-heading + #description-motivation", visible: :hidden)
    expect(page).to have_css(".section-heading + #description-goal", visible: :hidden)
  end

  it "displays social commitment section" do
    expect(page).to have_css(".section-heading + #social-commitment", visible: :hidden)
  end

  it "shows a list of rewards" do
    expect(page).to have_link "See all rewards"

    within "#rewards .card-grid .column:first-of-type" do
      within ".card__content" do
        within ".card__header" do
          expect(page).to have_content "Contributing €5"
          expect(page).to have_content "Acreditación de mecenazgo"
        end

        within ".card__text" do
          expect(page).to have_content "Tu nombre aparecerá en el apartado de agradecimientos de la documentación generada con el proyecto."
        end
      end

      within ".card__icondata:nth-child(2)" do
        expect(page).to have_css "svg.icon--info.icon"
        expect(page).to have_content "ACREDITACIÓN DE MECENAZGO"
      end

      within ".card__icondata:nth-child(3)" do
        expect(page).to have_css "svg.icon--tag.icon"
        expect(page).to have_content "CONTRIBUTING €5"
      end

      within ".card__footer" do
        within ".backers" do
          expect(page).to have_content("52 backers")
        end
      end
    end
  end
end
