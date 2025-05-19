# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    class CampaignsController < Decidim::SocialCrowdfunding::ApplicationController
      include HasGoteoConfiguration
      include ThermometerHelper

      helper CampaignHelper

      before_action :check_goteo_config

      def show
        if current_goteo_config.blank? || current_campaign.nil?
          flash[:alert] = current_goteo_config.blank? ? I18n.t("goteo_configuration.not_found", scope: "decidim.social_crowdfunding.campaigns.show") : I18n.t("campaign.not_found", scope: "decidim.social_crowdfunding.campaigns.show")
          redirect_to ResourceLocatorPresenter.new(current_participatory_space).path
        else
          enforce_permission_to :show, :campaign, campaign: current_campaign
          @thermometer_params = thermometer_params
        end
      end
    end
  end
end
