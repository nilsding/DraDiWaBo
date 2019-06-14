require "./base"
require "../print_usage"

module UseCase
  module CliCommands
    class Help < CliCommands::Base
      def self.command_name
        "help"
      end

      def self.description
        "Displays this usage text."
      end

      def call(_argv)
        UseCase::PrintUsage.call
      end
    end
  end
end
