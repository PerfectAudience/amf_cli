# frozen_string_literal: true

module AMF
  module Reports
    def self.start_date
      Date.today - 1.year
    end

    def self.sql_query
      {on_click_funnel: false, shsp_account: false, is_invoiced: false}
    end

    def self.accounts
      if Account.where(on_click_funnel: true).count == 0
        puts "No Funnel Accounts are set, maybe you need to run a Click Funnel report first?"
        exit 1
      end

      # Pull accounts that have been created in the last 12 months, but don't have a SharpSpring account nor an Invoice Status nor have already been seen on the Click Funnel report.
      acc_created_at = Account.arel_table[:acc_created_at]
      Account.where(acc_created_at.gt(start_date)).where(sql_query)
    end

    def self.amf_count
      puts "Of the accounts created after #{start_date}, there are #{accounts.count} records whom match #{sql_query}"
    end

    def self.amf_report
      puts Account.csv_header
      puts accounts.map(&:to_csv)
    end
  end
end
