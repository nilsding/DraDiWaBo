require "./base"
require "../bot"
require "../errors"

module Commands
  class StartBot < Base
    def self.description
      "Starts the telegram bot."
    end

    def call
      check_sanity!
      Bot.new.start
    end

    private def check_sanity!
      unless ENV.has_key?("TELEGRAM_API_TOKEN")
        raise Errors::ConfigurationError.new("TELEGRAM_API_TOKEN is not set")
      end
    end
  end
end
