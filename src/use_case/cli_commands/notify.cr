require "./base"
require "../notify"
require "../../errors"

module UseCase
  module CliCommands
    class Notify < CliCommands::Base
      def self.command_name
        "notify"
      end

      def self.description
        "Fetches toys and notifies the watchers"
      end

      def call(_argv)
        check_sanity!
        UseCase::Notify.call
      end

      private def check_sanity!
        unless ENV.has_key?("TELEGRAM_API_TOKEN")
          raise Errors::ConfigurationError.new("TELEGRAM_API_TOKEN is not set")
        end
      end
    end
  end
end
