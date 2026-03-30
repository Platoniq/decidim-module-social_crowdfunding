# frozen_string_literal: true

require "spec_helper"
require "decidim/social_crowdfunding/test/shared_contexts"

describe "Show campaign" do
  include_context "with stubs example api"
  include_context "with in progress campaign component"

  let!(:user) { create(:user, :confirmed, organization:) }

  context "when the component has a valid Goteo Configuration setted" do
    let!(:goteo_configuration) { create(:goteo_configuration, organization:) }

    before do
      login_as user, scope: :user

      component.settings = { campaign_slug: campaign_slug }
      component.save!

      visit_component
    end

    it "displays campaign media embed" do
      within ".responsive-embed" do
        expect(page).to have_css("iframe")
      end
    end

    context "when more than 1 day left" do
      before do
        Timecop.freeze(Date.parse(data["calendar"]["optimum"]) - 10.days)
        visit_component
      end

      it "displays campaign thermometer" do
        expect(page).to have_css(".thermometer-container")

        within ".thermometer-info" do
          within ".date" do
            expect(page).to have_content("10 days")
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

      it "displays the days left" do
        within ".thermometer-info .date" do
          expect(page).to have_content("10 days")
        end
      end
    end

    context "when less than 1 day left" do
      before do
        Timecop.freeze(Time.zone.parse(data["calendar"]["optimum"]) - 14.hours)
        visit_component
      end

      it "displays the hours left" do
        within ".thermometer-info .date" do
          expect(page).to have_content("Only 14 hours!")
        end
      end
    end

    it "shows a link with the Goteo logo" do
      within ".button--goteo" do
        expect(page).to have_content("DONATE IN")
        expect(page).to have_css(".goteo-logo")
      end
    end

    it "displays campaign status" do
      within ".campaign__status" do
        expect(page).to have_content("In campaign")
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

    context "when project has different locales" do
      before do
        stub_request(http_method, %r{\A#{api_url}/v4/projects/([\w-]+\z)?})
          .with(headers: { "Accept-Language" => "es" })
          .to_return(status: http_status, body: JSON.parse(file_fixture("goteo-project-finished-translated.json").read).to_json, headers: {})
      end

      it "displays title and description in English by default" do
        expect(page).to have_content("Goteeo API test project")
        expect(page).to have_content("This project tests the integration of the Social Crowdfunding module with the API.")
      end

      it "displays title in Spanish if that locale is selected" do
        find_by_id("trigger-dropdown-language-chooser").click
        click_on "Castellano"

        expect(page).to have_content("Proyecto de prueba API Goteo")
        expect(page).to have_content("En campaña")
      end
    end
  end
end
