# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    # Custom helpers, scoped to the social_crowdfunding engine.
    #
    module CampaignHelper
      GOTEO_ALLOWED_PEERTUBE_INSTANCES = ["peertube.plataformess.org", "framatube.org"].freeze

      def campaign_date
        date = case current_campaign.data["status"]
               when "in_campaign" then return campaign_days_remaining
               else return current_campaign.data["calendar"]["optimum"]
               end

        I18n.l(Date.parse(date), format: :decidim_short)
      end

      def campaign_date_label
        date_label = case current_campaign.data["status"]
                     when "in_editing" then "created"
                     when "in_review" then "updated"
                     when "in_campaign" then "remaining"
                     when "funded" then "finished"
                     when "unfunded" then "closed"
                     end

        t(date_label, scope: "decidim.social_crowdfunding.campaigns.date_label")
      end

      def campaign_days_remaining

        days_remaining = (current_campaign.data["calendar"]["optimum"].to_date - Time.zone.today).to_i

        if days_remaining <= 1
          hours_remaining = ((Time.zone.tomorrow.to_time - Time.zone.now) / 3600).to_i

          t("hours", hours: hours_remaining, scope: "decidim.social_crowdfunding.campaigns.date_remaining")
        else
          t("days", days: days_remaining, scope: "decidim.social_crowdfunding.campaigns.date_remaining")
        end
      end

      def campaign_grouped_costs
        (current_campaign.costs[I18n.locale.to_s] || current_campaign.costs.values.first).group_by { |c| c["type"] }
      end

      def campaign_status
        I18n.t(current_campaign.data["status"], scope: "decidim.social_crowdfunding.campaigns.statuses")
      end

      def campaign_status_class
        case current_campaign.data["status"]
        when "in_editing", "in_review" then "warning"
        when "in_campaign" then "secondary"
        when "funded", "fulfilled" then "success"
        when "unfunded" then "error"
        else "primary"
        end
      end

      def campaign_total_minimum
        (current_campaign.costs[I18n.locale.to_s] || current_campaign.costs.values.first).sum { |c| c["money"]["amount"] }
      end

      def campaign_total_optimum
        campaign_total_minimum + current_campaign.costs.select { |c| c["required"] == "False" }.sum { |c| c["amount"] }
      end

      def campaign_money(amount)
        unit = case current_campaign.data["balance"]["currency"]
               when "EUR" then "€"
               when "USD" then "$"
               when "GBP" then "£"
               end

        number_to_currency amount, unit:, precision: 0
      end

      def campaign_media_src
        return if current_campaign.data["video"]["src"].blank?

        parsed_url = parse_video_url(current_campaign.data["video"]["src"])

        case parsed_url[:type]
        when :peertube
          campaign_media_peertube(parsed_url[:id], parsed_url[:host], https: true, autoplay: false)
        when :vimeo
          campaign_media_vimeo(parsed_url[:id], https: true, autoplay: false)
        when :youtube
          campaign_media_youtube(parsed_url[:id], https: true, autoplay: false)
        end
      end

      private

      # --- GOTEO METHODS

      # https://github.com/GoteoFoundation/goteo/blob/live/src/Goteo/Model/Project/Media.php
      def campaign_media_vimeo(video, https: false, autoplay: false)
        autoplay_code = ";autoplay=1" if autoplay
        params = {
          protocol: https ? "https" : "http",
          video:,
          autoplay_code:
        }

        format("%{protocol}://player.vimeo.com/video/%{video}?title=0&byline=0&portrait=0%{autoplay_code}", params)
      end

      # https://github.com/GoteoFoundation/goteo/blob/live/src/Goteo/Model/Project/Media.php
      def campaign_media_youtube(video, https: false, autoplay: false)
        autoplay_code = "&autoplay=1" if autoplay
        params = {
          protocol: https ? "https" : "http",
          video:,
          autoplay_code:
        }

        format("%{protocol}://www.youtube.com/embed/%{video}?wmode=Opaque%{autoplay_code}", params)
      end

      # https://github.com/GoteoFoundation/goteo/blob/live/src/Goteo/Model/Project/Media.php
      def campaign_media_peertube(video, host, https: false, autoplay: false)
        autoplay_code = "&autoplay=1" if autoplay
        params = {
          protocol: https ? "https" : "http",
          video:,
          host:,
          autoplay_code:
        }
        format("%{protocol}://%{host}/videos/embed/%{video}?warningTitle=0%{autoplay_code}", params)
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
        # - Supported Peertube URL formats:
        #   - https://peertube.plataformess.org/videos/embed/ab236f8a-d17c-4ccf-b2dd-757ab4324dde
        #   - https://framatube.org/videos/embed/ab236f8a-d17c-4ccf-b2dd-757ab4324dde
        # - Also supports relative URLs:
        #   - //player.vimeo.com/video/25451551

        if url.match?(/(#{GOTEO_ALLOWED_PEERTUBE_INSTANCES.join("|")})/)
          type = :peertube
          regex = url.match(%{(http:|https:|)//(#{GOTEO_ALLOWED_PEERTUBE_INSTANCES.join("|")})/videos/embed/([A-Za-z0-9._%-]*)(&\S+)?})
          id = regex[3]
          host = regex[2]
        else
          regex = url.match(%r{(http:|https:|)//(player.|www.|m.)?(vimeo\.com|youtu(be\.com|\.be|be\.googleapis\.com))/(video/|embed/|watch\?v=|v/)?([A-Za-z0-9._%-]*)(&\S+)?})
          id = regex[6]

          if regex[3].match?("youtu")
            type = :youtube
            host = regex[3]
          elsif regex[3].match?("vimeo")
            type = :vimeo
            host = regex[3]
          end
        end

        { type:, id:, host: }
      end
    end
  end
end
