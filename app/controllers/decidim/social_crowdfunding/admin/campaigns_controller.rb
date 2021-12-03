# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      class CampaignsController < Decidim::Admin::Components::BaseController
        include Decidim::Paginable

        helper_method :campaigns

        def index; end

        def destroy
          enforce_permission_to :destroy, :campaign, campaign: campaign

          DestroyCampaign.call(campaign, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("campaigns.destroy.success", scope: "decidim.social_crowdfunding.admin")

              redirect_to root_url
            end
          end
        end

        def update
          enforce_permission_to :destroy, :campaign, campaign: campaign

          UpdateCampaign.call(campaign, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("campaigns.update.success", scope: "decidim.social_crowdfunding.admin")

              redirect_to root_url
            end

            on(:error) do
              flash[:alert] = I18n.t("campaigns.update.error", scope: "decidim.social_crowdfunding.admin")

              redirect_to root_url
            end
          end
        end

        private

        def campaign
          @campaign ||= Decidim::SocialCrowdfunding::Campaign.find_by(id: params[:id])
        end

        def campaigns
          paginate(collection)
        end

        def collection
          @collection ||= Decidim::SocialCrowdfunding::Campaign.where(organization: current_organization)
        end
      end
    end
  end
end
