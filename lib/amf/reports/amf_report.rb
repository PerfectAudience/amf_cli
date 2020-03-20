# frozen_string_literal: true

module AMF
  module Reports
    class AMF
      def initialize(sql_options={})
        AMF.validate

        @lifetime_spend = sql_options.delete(:lifetime_spend) || 5
        @start_date = sql_options.delete(:start_date) || 12.months.ago
        @sql_query = {on_click_funnel:           false,
                      shsp_account:              false,
                      is_invoiced:               false,
                      deactivated_all_campaigns: true,
                      has_stripe:                true}.merge(sql_options)
      end

      def params
        @sql_query.merge({lifetime_spend: @lifetime_spend, start_date: @start_date}).map { |k, v| "#{k}:#{v}" }.join(" ")
      end

      def accounts
        acc_created_at = Account.arel_table[:acc_created_at]
        Account.where(acc_created_at.gt(@start_date)).where(@sql_query).where("lifetime_spend > :spend", spend: @lifetime_spend)
      end

      def report
        puts Account.csv_header
        puts accounts.map(&:to_csv)
      end

      def info
        puts "There were #{accounts.count} accounts matching #{params}"
      end

      def filename
        "AMF Report with #{params}.csv"
      end

      ##
      # Class Methods
      ##

      def self.validate
        if Account.where(on_click_funnel: true).count == 0
          raise "No Funnel Accounts are set, maybe you need to run a Click Funnel report first?"
        end

        if Account.where(has_stripe: true).count == 0
          raise "No Stripe Accounts are set, maybe you need to load the stripe data first?"
        end
      end
    end
  end
end
