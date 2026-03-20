# frozen_string_literal: true

require "active_support/concern"

module Decidim
  # A controller concern to expose the current_campaign variable
  # which is retrieved with the component's :campaign_slug setting.
  module SocialCrowdfunding
    module HasCampaign
      extend ActiveSupport::Concern

      included do
        helper_method :current_campaign

        private

        def current_campaign
          @current_campaign ||= nil
          if current_component.settings[:campaign_slug].blank?
            flash[:alert] = t("not_selected", scope: "decidim.social_crowdfunding.admin.campaigns.fetch")
          else
            @current_campaign ||= Campaign.fetch(current_component.settings[:campaign_slug], current_goteo_config.ensure_valid_token!, current_component)

            flash[:alert] = t("not_found", scope: "decidim.social_crowdfunding.admin.campaigns.fetch") if @current_campaign.blank?
          end
          @current_campaign
        end
      end
    end
  end
end
