# frozen_string_literal: true

require "active_record"
require "otr-activerecord"

require "amf/cli"
require "amf/version"
require "amf/models/account"

Dir[File.join(__dir__, "amf", "reports", "*.rb")].sort.each { |file| require file }

Bundler.require(:default, ENV.fetch("RACK_ENV", :production).to_sym)
OTR::ActiveRecord.configure_from_file! "db/config.yml"
# Set LOGGER=true in your env if you wish to see the ActiveRecord SQL logs
ActiveRecord::Base.logger = ENV.fetch("LOGGER", false) ? Logger.new(STDOUT) : nil
