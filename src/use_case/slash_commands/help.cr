require "telegram_bot"

require "./base"

module UseCase
  module SlashCommands
    class Help < SlashCommands::Base
      def call(bot, msg, params)
        bot.reply msg, <<-EOF
Right now, I only know about this one command here.  Sorry to disappoint.
EOF
      end
    end
  end
end
