# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    # Custom helpers, scoped to the social_crowdfunding engine.
    #
    module ThermometerHelper
      MAX = 85
      MARGIN = 8

      def thermometer_params
        percentage = current_campaign.amount / current_campaign.minimum * 100

        minimum_size = current_campaign.minimum / current_campaign.optimum * MAX
        minimum_done = [percentage, 100].min

        minimum_label = minimum_size - MARGIN / 2

        optimum_size = MAX - minimum_size # For the separator between optimum + minimum

        minimum_left = 100 - minimum_done

        optimum_total_amount = current_campaign.optimum - current_campaign.minimum
        optimum_reached_amount = current_campaign.amount - current_campaign.minimum

        optimum_done = 0

        if minimum_done >= 100
          optimum_done = [optimum_reached_amount / optimum_total_amount * 100, 100].min
          optimum_left = 100 - optimum_done
        end

        # Over the optimum

        if optimum_done >= 100
          extra_done = (current_campaign.amount - current_campaign.optimum) * 100 / current_campaign.optimum * 0.5

          # Max 100% (1.5 the optimum)
          extra_done = [extra_done, 100].min
          extra_left = 100 - extra_done
        end

        # Percentage marker (calculated with margins)
        percentage_marker = if minimum_done < 100
                              minimum_done * minimum_size / 100 - MARGIN
                            elsif optimum_done < 100
                              minimum_size + optimum_done * optimum_size / 100 - MARGIN
                            else
                              [(MAX + (extra_done * 20) / 100) - MARGIN, 100 - MARGIN].min
                            end

        {
          extra_done: extra_done,
          extra_left: extra_left,
          minimum_done: minimum_done,
          minimum_label: minimum_label,
          minimum_left: minimum_left,
          minimum_size: minimum_size,
          optimum_done: optimum_done,
          optimum_left: optimum_left,
          optimum_size: optimum_size,
          percentage_marker: percentage_marker,
          percentage: percentage.to_i
        }
      end
    end
  end
end
