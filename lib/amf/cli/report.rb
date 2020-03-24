# frozen_string_literal: true

module AMF
  module CLI
    class Report < Thor
      package_name "AMF::Report"
      map "-I" => :info
      map "-F" => :filename
      default_task :report

      no_commands do
        def check_load
          if Account.count == 0
            puts "NO DATA: please run 'load' first\n\n"
            AMF::CLI::Load.new.help("mega")
            exit 1
          end
        end

        def sql_options(opts)
          opts.transform_keys(&:to_sym)
        end
      end

      desc "report", "Produces the AMF valid accounts report (default command)"
      method_option :opts, type: :hash, default: {}
      def report
        check_load
        AMF::Reports::AMF.new(sql_options(options[:opts])).report
      end

      desc "filename", "returns a unique filename based on teh currently selected parameters"
      method_option :opts, type: :hash, default: {}
      def filename
        check_load
        puts AMF::Reports::AMF.new(sql_options(options[:opts])).filename
      end

      desc "info", "Displays information about the AMF report using the current SQL parameters"
      method_option :opts, type: :hash, default: {}
      def info
        check_load
        puts AMF::Reports::AMF.new(sql_options(options[:opts])).info
      end
    end
  end
end
