# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return Decidim::SocialCrowdfunding::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin

        case permission_action.subject
        when :campaign
          allow! if permission_action.action == :show
        else
          allow!
        end

        permission_action
      end

      private

      def current_component
        @current_component ||= context.fetch(:current_component, nil)
      end
    end
  end
end
