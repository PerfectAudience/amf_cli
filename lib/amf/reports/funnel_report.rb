# frozen_string_literal: true

module AMF
  module Reports
    def self.funnel_report(file)
      print_headers = true

      CSV.foreach(file, headers: true) do |row|
        if print_headers
          puts row.to_h.keys.to_csv
          print_headers = false
        end

        email = row["Email"].to_s.strip.downcase

        if email && !email.empty?
          account = Account.where(contact_email: email).first

          unless account
            warn "Cannot find account with email #{email}"
            next
          end

          row["Account Created"] = account.acc_created_at
          row["Did They Start Trial"] = account.trial_started?.to_s
          row["Dashboard URL"] = account.dashboard_url
          row["Total Spend"] = account.lifetime_spend

          # We now know this is a current PA customer, so set this flag on the record
          account.update on_click_funnel: true
        else
          warn "ERROR: Could not determine email for #{row.inspect}"
        end

        puts row.to_csv
      end
    end
  end
end
