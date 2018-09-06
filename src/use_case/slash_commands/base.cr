require "telegram_bot"

require "../base"

module UseCase
  module SlashCommands
    abstract class Base < UseCase::Base
      abstract def call(bot : TelegramBot::Bot, msg : TelegramBot::Message, params : Array(String)?)
    end
  end
end
