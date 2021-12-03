# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      class CampaignsController < Decidim::Admin::Components::BaseController
        include Decidim::Paginable

        helper_method :campaigns

        def edit; end

        def destroy
          enforce_permission_to :destroy, :campaign, campaign: campaign

          DestroyCampaign.call(campaign, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("campaigns.destroy.success", scope: "decidim.social_crowdfunding.admin")

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
          @collection ||= Decidim::SocialCrowdfunding::Campaign.all
        end
      end
    end
  end
end
