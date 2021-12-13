# frozen_string_literal: true

require "decidim/social_crowdfunding/admin"
require "decidim/social_crowdfunding/admin_engine"
require "decidim/social_crowdfunding/goteo"
require "decidim/social_crowdfunding/engine"
require "decidim/social_crowdfunding/component"

module Decidim
  module SocialCrowdfunding
    autoload :Markdown, "decidim/social_crowdfunding/markdown"
  end
end
