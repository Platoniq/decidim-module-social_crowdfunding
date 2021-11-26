# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless user

        return Decidim::SocialCrowdfunding::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin

        case permission_action.subject
        when :campaign
          allow_campaign?
        else
          allow!
        end

        permission_action
      end

      def allow_campaign?
        allow! if permission_action.action == :create
      end

      private

      def current_component
        @current_component ||= context.fetch(:current_component, nil)
      end
    end
  end
end
