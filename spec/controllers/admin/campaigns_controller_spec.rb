# frozen_string_literal: true

require "spec_helper"

module Decidim::SocialCrowdfunding::Admin
  describe CampaignsController do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, :confirmed, :admin, organization:) }
    let(:participatory_space) { create(:participatory_process, organization:) }
    let(:component) { create(:component, manifest_name: "social_crowdfunding_campaign", participatory_space:) }
    let!(:campaign) { create(:campaign, organization:) }
    let!(:other_campaign) { create(:campaign, slug: "la-benefica") }

    before do
      request.env["decidim.current_organization"] = organization
      request.env["decidim.current_participatory_space"] = participatory_space
      request.env["decidim.current_component"] = component
      sign_in user
      allow(controller).to receive(:root_url).and_return("/")
    end

    describe "DELETE #destroy" do
      it "destroys a campaign of the organization" do
        delete :destroy, params: { id: campaign.id }

        expect(Decidim::SocialCrowdfunding::Campaign.exists?(campaign.id)).to be(false)
      end

      context "with a campaign from another organization" do
        it "raises not found" do
          expect { delete :destroy, params: { id: other_campaign.id } }.to raise_error(ActiveRecord::RecordNotFound)
          expect(Decidim::SocialCrowdfunding::Campaign.exists?(other_campaign.id)).to be(true)
        end
      end
    end

    describe "PATCH #update" do
      context "with a campaign from another organization" do
        it "raises not found" do
          expect { patch :update, params: { id: other_campaign.id } }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
