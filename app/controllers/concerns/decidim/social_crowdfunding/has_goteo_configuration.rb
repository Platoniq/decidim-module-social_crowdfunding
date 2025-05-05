# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module SocialCrowdfunding
    module HasGoteoConfiguration
      extend ActiveSupport::Concern

      included do
        helper_method :current_goteo_config, :current_goteo_config_valid?

        private

        def current_goteo_config_valid?
          current_goteo_config&.token_valid?
        end

        def current_goteo_config
          @current_config ||= GoteoConfiguration.find_by(id: current_component.settings.goteo_configuration_id)

          flash[:alert] = t("not_found", scope: "decidim.social_crowdfunding.admin.goteo_configurations.fetch") if @current_config.blank?

          @current_config
        end

        def check_goteo_config
          current_goteo_config&.update_token unless current_goteo_config_valid?
        end
      end
    end
  end
end
