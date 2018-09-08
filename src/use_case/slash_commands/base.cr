require "telegram_bot"

require "../base"

module UseCase
  module SlashCommands
    abstract class Base < UseCase::Base
      def self.command_name
        raise NotImplementedError.new("Implement #{self.class}.command_name!")
      end

      def self.help_text
        ""
      end

      abstract def call(bot : TelegramBot::Bot, msg : TelegramBot::Message, params : Array(String)?)
    end
  end
end
