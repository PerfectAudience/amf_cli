# frozen_string_literal: true

require "thor"
require_relative "cli/load"
require_relative "cli/report"

module AMF
  module CLI
    class CLI < Thor
      package_name "AMF"
      map "-v" => :version

      def self.exit_on_failure?
        true
      end

      desc "version", "Displays the program version information"
      def version
        puts "#{PROGRAM_NAME} v#{VERSION}"
      end

      desc "count", "Returns the number of Account records in the system"
      def count
        puts "We have #{Account.count} records in the DB"
      end

      desc "diff_emails <FILE1> <FILE2>",
           "Takes two email lists and produces a list of those who appear in FILE1 but do not appear in FILE2"
      def diff_emails(file1, file2)
        if !File.exist?(file1) || !File.exist?(file2)
          puts "Whoops! One (or both) of the input files does not exist"
          exit 1
        end

        list1 = File.open(file1).readlines.map(&:strip).map(&:downcase) if File.exist? file1
        list2 = File.open(file2).readlines.map(&:strip).map(&:downcase) if File.exist? file2

        puts(list1.reject { |e| list2.include?(e) })
      end

      desc "load", "Commands used to preload data into the system"
      subcommand "load", Load

      desc "report", "Commands used to create various reports"
      subcommand "report", Report
    end

    def self.start
      CLI.start
    end
  end
end
