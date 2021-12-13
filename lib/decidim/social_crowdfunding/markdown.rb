# frozen_string_literal: true

require "redcarpet"

module Decidim
  module SocialCrowdfunding
    # This class parses a string from plain text (markdown) and
    # renders it as HTML.
    class Markdown < ::Redcarpet::Render::Base
      delegate :render, to: :markdown

      private

      def markdown
        @markdown ||= ::Redcarpet::Markdown.new(renderer)
      end

      def renderer
        @renderer ||= Decidim::SocialCrowdfunding::MarkdownRender.new
      end
    end

    # Custom markdown renderer for SocialCrowdfunding campaigns text
    class MarkdownRender < ::Redcarpet::Render::Safe
      def initialize(extensions = {})
        super({
          autolink: true,
          escape_html: false,
          filter_html: true,
          hard_wrap: true,
          lax_spacing: false,
          no_images: false,
          no_styles: true,
          link_attributes: {
            target: "_blank"
          }
        }.merge(extensions))
      end

      # removes header tags
      def header(title, _level)
        title
      end

      # prevents empty <p/>
      def paragraph(text)
        return if text.blank?

        "<p>#{text}</p>"
      end
    end
  end
end
