require "sidekiq/cli"

require "./base"

module UseCase
  module CliCommands
    class StartWorker < CliCommands::Base
      def self.command_name
        "worker"
      end

      def self.description
        "Starts the Sidekiq worker."
      end

      def call(_argv)
        check_sanity!
        cli = Sidekiq::CLI.new

        server = cli.configure do |config|
          # middleware would be added here
        end

        cli.run(server)
      end

      private def check_sanity!
        unless ENV.has_key?("TELEGRAM_API_TOKEN")
          raise Errors::ConfigurationError.new("TELEGRAM_API_TOKEN is not set")
        end
      end
    end
  end
end
