# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    # This controller is the abstract class from which all other controllers of
    # this engine inherit.
    #
    # Note that it inherits from `Decidim::Components::BaseController`, which
    # override its layout and provide all kinds of useful methods.
    class ApplicationController < Decidim::Components::BaseController
      helper_method :current_campaign

      private

      def current_campaign
        @current_campaign ||= Campaign.fetch(current_component.settings[:campaign_id], current_organization)
      end
    end
  end
end
