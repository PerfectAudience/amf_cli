# frozen_string_literal: true

module AMF
  module Reports
    def self.start_date
      1.year.ago
    end

    def self.sql_query
      {on_click_funnel: false, shsp_account: false, is_invoiced: false, deactivated_all_campaigns: false, has_stripe: true}
    end

    def self.lifetime_spend_min
      5
    end

    def self.accounts
      if Account.where(on_click_funnel: true).count == 0
        puts "No Funnel Accounts are set, maybe you need to run a Click Funnel report first?"
        exit 1
      end

      if Account.where(has_stripe: true).count == 0
        puts "No Stripe Accounts are set, maybe you need to load the stripe data first?"
        exit 1
      end

      # Pull accounts that have been created in the last 12 months, but don't have a SharpSpring account nor an Invoice Status nor have already been seen on the Click Funnel report.
      acc_created_at = Account.arel_table[:acc_created_at]
      Account.where(acc_created_at.gt(start_date)).where(sql_query).where("lifetime_spend > :spend", spend: lifetime_spend_min)
    end

    def self.amf_count
      puts "There were #{accounts.count} accounts matching #{amf_params}"
    end

    def self.amf_report
      puts Account.csv_header
      puts accounts.map(&:to_csv)
    end

    def self.amf_params
      sql_query.merge({lifetime_spend: lifetime_spend_min, start_date: start_date}).map { |k, v| "#{k}:#{v}" }.join(" ")
    end

    def self.amf_filename
      "AMF Report with #{amf_params}.csv"
    end
  end
end
