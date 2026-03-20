# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      class GoteoConfigurationsController < Decidim::Admin::Components::BaseController
        include Decidim::Paginable
        include HasGoteoConfiguration

        helper_method :goteo_configurations

        def new
          enforce_permission_to :create, :goteo_configuration

          @form = Decidim::SocialCrowdfunding::Admin::GoteoConfigurationForm.new
        end

        def create
          enforce_permission_to :create, :goteo_configuration

          @form = form(Decidim::SocialCrowdfunding::Admin::GoteoConfigurationForm).from_params(params)

          if @form.invalid?
            flash.now[:alert] = I18n.t("goteo_configurations.create.invalid", scope: "decidim.social_crowdfunding.admin")
            return render action: "new"
          end

          config = Decidim::SocialCrowdfunding::GoteoConfiguration.find_or_initialize_by(organization: current_organization)
          config.update!(client_id: @form.client_id, client_secret: @form.client_secret)

          flash[:notice] = I18n.t("goteo_configurations.create.success", scope: "decidim.social_crowdfunding.admin")
          redirect_to goteo_configurations_path
        end

        def refresh
          enforce_permission_to :create, :goteo_configuration

          config = Decidim::SocialCrowdfunding::GoteoConfiguration.find(params[:id])
          config.update_token

          flash[:notice] = I18n.t("goteo_configurations.refresh.success", scope: "decidim.social_crowdfunding.admin")
          redirect_to goteo_configurations_path
        rescue Decidim::SocialCrowdfunding::Goteo::Api::Error => e
          flash[:alert] = I18n.t("goteo_configurations.refresh.invalid", scope: "decidim.social_crowdfunding.admin", error: e.message)
          redirect_to goteo_configurations_path
        end

        def destroy
          enforce_permission_to :destroy, :goteo_configuration

          Decidim::SocialCrowdfunding::GoteoConfiguration.find_by(id: params[:id]).destroy!

          flash[:notice] = I18n.t("goteo_configurations.destroy.success", scope: "decidim.social_crowdfunding.admin")

          redirect_to goteo_configurations_path
        end

        private

        def goteo_configurations
          paginate(collection)
        end

        def collection
          @collection ||= Decidim::SocialCrowdfunding::GoteoConfiguration.where(organization: current_organization)
        end
      end
    end
  end
end
