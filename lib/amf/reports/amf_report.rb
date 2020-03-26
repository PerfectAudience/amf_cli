# frozen_string_literal: true

module AMF
  module Reports
    class AMF
      def initialize(sql_options={})
        AMF.validate

        @start_date = AMF.convert_to_date(sql_options.delete(:start_date))
        @lifetime_spend = sql_options.delete(:lifetime_spend) { 5 }
        @sql_query = {on_click_funnel:           false,
                      shsp_account:              false,
                      is_invoiced:               false,
                      amf_active:                false,
                      deactivated_all_campaigns: true,
                      has_stripe:                true}.merge(sql_options)
      end

      def params
        @sql_query.merge({lifetime_spend: @lifetime_spend, start_date: @start_date.to_s})
                  .map { |k, v| "#{k}:#{v}" }.join(", ")
      end

      def accounts
        # acc_created_at = Account.arel_table[:acc_created_at]
        Account.where(:acc_created_at.gte => @start_date)
               .where(:lifetime_spend.gt => @lifetime_spend)
               .where(@sql_query)
      end

      def report
        puts Account.csv_header
        puts accounts.map(&:to_csv)
      end

      def info
        "There were #{accounts.count} accounts matching #{params}"
      end

      def filename
        "AMF-Report.#{params}.csv".gsub(/,\s+/, ".").gsub(/\s+/, "_")
      end

      ##
      # Class Methods
      ##

      def self.convert_to_date(date)
        return 12.months.ago.to_date if date.nil?

        date =~ /^\d+\.(month|year)s?\.ago$/ ? eval(date).to_date : date.to_date # rubocop:disable Security/Eval
      end

      def self.validate
        if Account.where(on_click_funnel: true).count.zero?
          warn "No Funnel Accounts are set, maybe you need to load the Click Funnel data first?"
          exit 1
        end

        if Account.where(has_stripe: true).count.zero? # rubocop:disable Style/GuardClause
          warn "No Stripe Accounts are set, maybe you need to load the stripe data first?"
          exit 1
        end
      end
    end
  end
end
