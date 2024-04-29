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
    expect(page).to have_css(".h3.decorator + #costs", visible: :hidden)
    expect(page).to have_css(".h3.decorator + #description-general", visible: :all)
    expect(page).to have_css(".h3.decorator + #description-about", visible: :hidden)
    expect(page).to have_css(".h3.decorator + #description-motivation", visible: :hidden)
    expect(page).to have_css(".h3.decorator + #description-goal", visible: :hidden)
  end

  it "displays social commitment section" do
    expect(page).to have_css(".h3.decorator + #social-commitment", visible: :hidden)
  end

  it "shows a list of rewards" do
    expect(page).to have_link "See all rewards"

    within "#rewards .card__list-list .card__container:first-of-type" do
      within ".card__content" do
        expect(page).to have_content "Contributing €5"
        expect(page).to have_content "Acreditación de mecenazgo"

        within ".card__text" do
          expect(page).to have_content "Tu nombre aparecerá en el apartado de agradecimientos de la documentación generada con el proyecto."
        end
        within ".card__grid-metadata .card__icondata:nth-child(1)" do
          expect(page).to have_css "svg"
          expect(page).to have_content "ACREDITACIÓN DE MECENAZGO"
        end
        within ".card__grid-metadata .card__icondata:nth-child(2)" do
          expect(page).to have_css "svg"
          expect(page).to have_content "CONTRIBUTING €5"
        end
      end

      within ".footer__content" do
        within ".backers" do
          expect(page).to have_content("52 backers")
        end
      end
    end
  end
end
