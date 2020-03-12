# frozen_string_literal: true

require "thor"

module AMF
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    no_commands do
      def check_load
        if Account.count == 0
          puts "NO DATA: please run 'load' first\n\n"
          help
          exit 1
        end
      end
    end

    desc "version", "Displays the program version information"
    def version
      puts "#{PROGRAM_NAME} v#{VERSION}"
    end

    desc "load FILE", "reads a MEGA report file and loads it into the working database"
    method_option :prune, type: :boolean, aliases: "-P"
    def load(load_file)
      if File.exist? load_file
        Account.load_csv load_file, options[:prune]
        count
      else
        puts "ERROR: The file '#{load_file}' does not exist\n\n"
        help
      end
    end

    desc "count", "Returns the number of Account records in the system"
    def count
      puts "We have #{Account.count} records in the DB"
    end

    desc "funnel_report <FILE>", "Returns a report of users which match records in FILE against the MEGA data"
    def funnel_report(funnel_file)
      check_load

      if File.exist? funnel_file
        AMF::Reports.funnel_report funnel_file
      else
        puts "ERROR: The file '#{funnel_file}' does not exist\n\n"
        help
      end
    end

    desc "amf_report", "Produces the AMF valid accounts report"
    def amf_report
      check_load
      AMF::Reports.amf_report
    end

    desc "amf_report_info", "Display the number of records selected for the AMF Report"
    def amf_report_info
      check_load
      AMF::Reports.amf_count
    end

    desc "diff_emails <FILE1> <FILE2>", "Takes two email lists and produces a list of those who appear in FILE1 but do not appear in FILE2"
    def diff_emails(file1, file2)
      if !File.exist?(file1) || !File.exist?(file2)
        puts "Whoops! One (or both) of the input files does not exist"
        exit 1
      end

      list1 = File.open(file1).readlines.map(&:strip).map(&:downcase) if File.exist? file1
      list2 = File.open(file2).readlines.map(&:strip).map(&:downcase) if File.exist? file2

      puts list1.reject { |e| list2.include?(e) }
    end
  end
end
