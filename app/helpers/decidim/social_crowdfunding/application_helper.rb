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

      def campaign_date
        date = case current_campaign.data["status"]
               when "editing" then current_campaign.data["date-created"]
               when "reviewing" then current_campaign.data["date-updated"]
               when "in_campaign" then return days_remaining
               when "funded", "fulfilled" then current_campaign.data["date-created"]
               when "unfunded" then current_campaign.data["date-closed"]
               end

        I18n.l Date.parse(date), format: :decidim_short
      end

      def days_remaining
        "days remaining: not implemented in api"
      end

      def campaign_grouped_costs
        current_campaign.data["costs"].group_by { |c| c["type"] }
      end

      def campaign_needs
        current_campaign.data["needs"]
      end

      def campaign_rewards
        current_campaign.data["rewards"].select { |r| r["type"] == "individual" }
      end

      def campaign_social_commitments
        current_campaign.data["rewards"].select { |r| r["type"] == "social" }
      end

      def campaign_status
        I18n.t(current_campaign.data["status"], scope: "decidim.social_crowdfunding.campaigns.statuses")
      end

      def campaign_status_class
        case current_campaign.data["status"]
        when "editing", "reviewing" then "warning"
        when "in_campaign" then "secondary"
        when "funded", "fulfilled" then "success"
        when "unfunded" then "error"
        else "primary"
        end
      end

      def campaign_total_minimum
        current_campaign.data["costs"].select { |c| c["required"] == "True" }.sum { |c| c["amount"] }
      end

      def campaign_total_optimum
        campaign_total_minimum + current_campaign.data["costs"].select { |c| c["required"] == "False" }.sum { |c| c["amount"] }
      end

      def campaign_money(amount)
        unit = case current_campaign.data["currency"]
               when "EUR" then "€"
               when "USD" then "$"
               when "GBP" then "£"
               end

        number_to_currency amount, unit: unit, precision: 0
      end

      def campaign_media_src
        parsed_url = parse_video_url(current_campaign.data["video-url"])

        case parsed_url[:type]
        when :vimeo
          campaign_media_vimeo(parsed_url[:id], https: true, autoplay: false)
        when :youtube
          campaign_media_youtube(parsed_url[:id], https: true, autoplay: false)
        end
      end

      # --- GOTEO METHODS

      # https://github.com/GoteoFoundation/goteo/blob/live/src/Goteo/Model/Project/Media.php
      def campaign_media_vimeo(video, https: false, autoplay: false)
        autoplay_code = ";autoplay=1" if autoplay
        params = {
          protocol: https ? "https" : "http",
          video: video,
          autoplay_code: autoplay_code
        }

        format("%{protocol}://player.vimeo.com/video/%{video}?title=0&byline=0&portrait=0%{autoplay_code}", params)
      end

      # https://github.com/GoteoFoundation/goteo/blob/live/src/Goteo/Model/Project/Media.php
      def campaign_media_youtube(video, https: false, autoplay: false)
        autoplay_code = "&autoplay=1" if autoplay
        params = {
          protocol: https ? "https" : "http",
          video: video,
          autoplay_code: autoplay_code
        }

        format("%{protocol}://www.youtube.com/embed/%{video}?wmode=Opaque%{autoplay_code}", params)
      end

      # https://github.com/GoteoFoundation/goteo/blob/live/public/assets/js/forms.js
      def parse_video_url(url)
        # - Supported YouTube URL formats:
        #   - http://www.youtube.com/watch?v=My2FRPA3Gf8
        #   - http://youtu.be/My2FRPA3Gf8
        #   - https://youtube.googleapis.com/v/My2FRPA3Gf8
        #   - https://m.youtube.com/watch?v=My2FRPA3Gf8
        # - Supported Vimeo URL formats:
        #   - http://vimeo.com/25451551
        #   - http://player.vimeo.com/video/25451551
        # - Also supports relative URLs:
        #   - //player.vimeo.com/video/25451551

        regex = url.match(%r{(http:|https:|)//(player.|www.|m.)?(vimeo\.com|youtu(be\.com|\.be|be\.googleapis\.com))/(video/|embed/|watch\?v=|v/)?([A-Za-z0-9._%-]*)(&\S+)?})

        if regex[3].match?("youtu")
          type = :youtube
        elsif regex[3].match?("vimeo")
          type = :vimeo
        end

        { type: type, id: regex[6] }
      end
    end
  end
end
