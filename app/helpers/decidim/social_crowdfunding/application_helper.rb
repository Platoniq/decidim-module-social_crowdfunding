# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    # Custom helpers, scoped to the social_crowdfunding engine.
    #
    module ApplicationHelper
      include Decidim::TranslatableAttributes

      # Private: Initializes the Markdown parser
      def markdown
        @markdown ||= Decidim::SocialCrowdfunding::Markdown.new
      end

      # Private: converts the string from markdown to html
      def render_markdown(string)
        markdown.render(string).html_safe
      end
    end
  end
end
