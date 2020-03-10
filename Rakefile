# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

load "tasks/otr-activerecord.rake"

namespace :db do
  # Some db tasks require your app code to be loaded; they'll expect to find it here
  task :environment do
    require "amf"
  end
end

task default: :spec
