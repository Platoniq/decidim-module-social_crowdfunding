# frozen_string_literal: true

require "spec_helper"
require "decidim/social_crowdfunding/test/shared_contexts"

describe "Show campaign" do
  include_context "with stubs example api"
  include_context "with finished campaign component"

  let!(:user) { create(:user, :confirmed, organization:) }

  context "when the component has not a valid Goteo Configuration setted" do
    before do
      login_as user, scope: :user
    end

    it "displays an alert" do
      expect(page).to have_content("This component doesn't have a valid Goteo configuration setted, so the campaign information can't be fetched.")
    end
  end

  context "when the component has a valid Goteo Configuration setted" do
    let!(:goteo_configuration) { create(:goteo_configuration, organization:) }

    before do
      login_as user, scope: :user

      component.settings = { "goteo_configuration_id": goteo_configuration.id, "campaign_slug": campaign_slug }
      component.save!

      visit_component
    end

    it "displays campaign media embed" do
      within ".responsive-embed" do
        expect(page).to have_css("iframe")
      end
    end

    it "displays campaign thermometer" do
      expect(page).to have_css(".thermometer-container")

      within ".thermometer-info" do
        within ".date" do
          expect(page).to have_content("2022-04-20")
        end
        within ".reached" do
          expect(page).to have_content("€31,456")
        end
        within ".optimum" do
          expect(page).to have_content("€50,000")
        end
        within ".minimum" do
          expect(page).to have_content("€40,000")
        end
      end

      within ".thermometer-container .percentage" do
        expect(page).to have_content("78%")
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
        expect(page).to have_content("Funded")
      end
    end

    it "displays project description sections" do
      expect(page).to have_css(".h3.decorator + #costs", visible: :hidden)
      expect(page).to have_css(".h3.decorator + #description-general", visible: :all)
    end

    it "shows a list of rewards" do
      expect(page).to have_link "See all rewards"

      within "#rewards .card__list-list .card__container:first-of-type" do
        within ".card__content" do
          expect(page).to have_content "Contributing €5"
          expect(page).to have_content "First reward"

          within ".card__text" do
            expect(page).to have_content "This is a reward"
          end
          within ".card__grid-metadata .card__icondata:nth-child(1)" do
            expect(page).to have_css "svg"
            expect(page).to have_content "FIRST REWARD"
          end
          within ".card__grid-metadata .card__icondata:nth-child(2)" do
            expect(page).to have_css "svg"
            expect(page).to have_content "CONTRIBUTING €5"
          end
        end

        within ".footer__content" do
          within ".backers" do
            expect(page).to have_content("2 backers")
          end
        end
      end
    end
  end
end
