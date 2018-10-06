require "sidekiq/web"

require "./base"

module UseCase
  module CliCommands
    class StartSidekiqWeb < CliCommands::Base
      def self.command_name
        "web"
      end

      def self.description
        "Starts the Sidekiq web interface."
      end

      def call(_argv)
        check_sanity!

        Kemal.config do |_config|
        end

        Kemal::Session.config do |config|
          config.secret = ENV.fetch("WEB_SESSION_SECRET")
        end

        Kemal.run
      end

      private def check_sanity!
        unless ENV.has_key?("WEB_SESSION_SECRET")
          raise Errors::ConfigurationError.new("WEB_SESSION_SECRET is not set")
        end
      end
    end
  end
end
