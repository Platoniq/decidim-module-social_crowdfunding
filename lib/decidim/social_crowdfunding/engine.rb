# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module SocialCrowdfunding
    # This is the engine that runs on the public interface of social_crowdfunding.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::SocialCrowdfunding

      routes do
        # Add engine routes here
        root to: "campaigns#show"
      end

      initializer "decidim_social_crowdfunding.snippets" do |app|
        app.config.enable_html_header_snippets = true
      end

      initializer "decidim_social_crowdfunding.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_social_crowdfunding.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::SocialCrowdfunding::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::SocialCrowdfunding::Engine.root}/app/views")
      end
    end
  end
end
