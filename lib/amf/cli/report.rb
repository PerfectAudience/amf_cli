# frozen_string_literal: true

module AMF
  module CLI
    class Report < Thor
      package_name "AMF::Report"
      map "-I" => :info
      map "-F" => :filename

      no_commands do
        def check_load
          if Account.count == 0
            puts "NO DATA: please run 'load' first\n\n"
            AMF::CLI::Load.new.help("mega")
            exit 1
          end
        end
      end

      desc "amf", "Produces the AMF valid accounts report"
      def amf
        check_load
        AMF::Reports::AMF.new.report
      end

      desc "filename", "returns a unique filename based on teh currently selected parameters"
      def filename
        check_load
        puts AMF::Reports::AMF.new.filename
      end

      desc "info", "Displays information about the AMF report using the current SQL parameters"
      def info
        check_load
        puts AMF::Reports::AMF.new.info
      end
    end
  end
end
