require "telegram_bot"

require "./base"
require "../../application"

module UseCase
  module SlashCommands
    class Watch < SlashCommands::Base
      def self.command_name
        "watch"
      end

      def self.help_text
        "Tell me which toy and size I should look for."
      end

      def call(bot, msg, _params)
        return log_warning if msg.from.nil?

        bot.send_message(
          chat_id: msg.chat.id.to_s,
          text: "Please tell me which toy I should look for.",
          disable_notification: true,
          reply_to_message_id: msg.message_id,
          reply_markup: mock_keyboard_markup
        )
      end

      private def log_warning
        Application.logger.warn "got an addWatch request using a message without a user -- ignoring"
      end

      private def mock_keyboard_markup
        TelegramBot::ReplyKeyboardMarkup.new(
          keyboard: [
 ["Flint the Uncut Studded Dragon"],
 ["Nox the Night Drake"],
 ["Archer the Ultimate Fantasy"],
 ["Vergil the Drippy Dragon"],
 ["Clayton the Earth Dragon"],
 ["Cole the Dane"],
 ["Bruiser the Fusion"],
 ["Crackers the Cockatrice"],
 ["Glyph the Gryphon"],
 ["Xar the Karabos"],
 ["Elden the Faerie Dragon"],
 ["David the Werewolf"],
 ["Duke the Bad Dragon"],
],
          one_time_keyboard: true,
          selective: true
        )
      end
    end
  end
end
