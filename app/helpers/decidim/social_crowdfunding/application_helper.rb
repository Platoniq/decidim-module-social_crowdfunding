# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    # Custom helpers, scoped to the social_crowdfunding engine.
    #
    module ApplicationHelper
      include Decidim::TranslatableAttributes

      def campaign_date(data)
        date = case data["status"]
               when "editing" then data["date-created"]
               when "reviewing" then data["date-updated"]
               when "in-campaign" then days_remaining(data)
               when "funded", "fulfilled" then data["date-created"]
               when "unfunded" then data["date-closed"]
        end

        Date.parse(date)
      end

      def campaign_status(data)
        I18n.t(data["status"], scope: "decidim.social_crowdfunding.campaigns.statuses")
      end

      def campaign_media(video_url)
        parsed_url = parse_video_url(video_url)

        case parsed_url[:type]
        when :vimeo
          campaign_media_vimeo(parsed_url[:id], https: true, autoplay: false)
        when :youtube
          campaign_media_youtube(parsed_url[:id], https: true, autoplay: false)
        end
      end

      def campaign_money(amount, currency)
        unit = case currency
               when "EUR" then "€"
               when "USD" then "$"
               when "GBP" then "£"
        end

        number_to_currency amount, unit: unit, precision: 0
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
