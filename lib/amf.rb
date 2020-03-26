# frozen_string_literal: true

require "mongoid"
require "csv"
require "amf/cli"
require "amf/version"

require "amf/models/account"

# Load complete directories
load_directories = %w[reports]

load_directories.each { |ftype| Dir[File.join(__dir__, "amf", ftype, "*.rb")].sort.each { |file| require file } }

Bundler.require(:default, ENV.fetch("RACK_ENV", :production).to_sym)
Mongoid.load! "db/config_mongo.yml"
