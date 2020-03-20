# frozen_string_literal: true

module AMF
  module CLI
    class Load < Thor
      no_commands do
        def check_file(file)
          unless File.exist? file
            warn "ERROR: The file '#{file}' does not exist"
            exit 1
          end
          true
        end
      end

      desc "mega FILE", "reads a MEGA report file and loads it into the working database"
      method_option :prune, type: :boolean, aliases: "-P"
      def mega(file)
        if check_file(file)
          AMF::Account.load_mega file, options[:prune]
          count
        end
      end

      desc "funnel FILE", "loads and produces the Click Funnel report"
      def funnel(file)
        AMF::Reports.funnel_report(file) if check_file(file)
      end

      desc "stripe FILE", "loads stripe data"
      def stripe(file)
        AMF::Account.load_stripe(file) if check_file(file)
      end

      desc "amfed FILE", "loads records who have had AMF activated"
      def amfed(file)
        AMF::Account.load_amf(file) if check_file(file)
      end
    end
  end
end
