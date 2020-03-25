# frozen_string_literal: true

require "csv"
require "active_record"

module AMF
  class Account < ActiveRecord::Base
    validates :account_id, presence: true
    validates :contact_email, presence: true, uniqueness: {case_insensitive: true}

    def trial_started?
      lifetime_spend >= 0.01
    end

    def dashboard_url
      "https://app.perfectaudience.com/sites/#{account_id}"
    end

    def to_csv
      CSV.generate { |csv| csv << attributes.values }
    end

    ##
    # Class Methods
    ##
    def self.csv_header
      CSV.generate { |csv| csv << Account.attribute_names }
    end

    def self.normalize_field(field)
      field.gsub("?", "").gsub(/\s+/, "_").downcase
    end

    def self.load_mega(file, prune=false)
      if prune
        puts "Deleting all records"
        delete_all
      end

      puts "Loading #{file} into the DB"
      CSV.foreach(file, headers: true) { |record| load record }

      puts "#{Account.count} records added."
    end

    def self.load_stripe(file)
      CSV.foreach(file, headers: true) do |row|
        email = row["Email"].to_s.strip.downcase

        account = Account.where(contact_email: email).first unless email.empty?

        unless account
          warn "Account with #{email} could not be found in the MEGA data"
          next
        end

        account.update has_stripe: true
      end

      puts "#{Account.where(has_stripe: true).count} records added."
    end

    def self.load_amf(file, header=nil) # rubocop:disable Metrics/AbcSize
      count = 0

      CSV.foreach(file, headers: !header.nil?) do |row|
        if header.nil?
          email = row[0].to_s.strip.downcase
        elsif row.has_key? header
          email = row[header].to_s.strip.downcase
        end

        if email.blank?
          warn "Could not find an email field in the input data"
          return false
        end

        account = Account.where(contact_email: email).first

        unless account
          warn "Account with #{email} could not be found in the MEGA data"
          next
        end

        account.update amf_active: true
        count += 1
      end

      puts "#{count} records were updated" if count.positive?
      puts "#{Account.where(amf_active: true).count} total records AMFed."
    end

    def self.load(record) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      account_id = record["Account ID"].to_s.strip
      email = record["Contact Email"].to_s.strip.downcase

      return unless account_id && !email.blank? && email =~ /^\S+@\S+$/

      where(account_id: account_id, contact_email: email).first_or_create do |account|
        record.to_h.each_key do |field|
          next if field.include? ["Account ID", "Contact Email"]

          account[Account.normalize_field(field)] = record[field]
        end

        if account.changed?
          unless account.valid? && account.save
            warn "Unable to create record for #{email}: #{account.errors.messages.inspect}"
          end
        end
      end
    end
  end
end
