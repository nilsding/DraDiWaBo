require "./base"

module UseCase
  module SlashCommands
    class Start < SlashCommands::Base
      def call(bot, msg, params)
        bot.reply msg, <<-EOF
Welcome to the Dragon Dick Watchbot!

I periodically monitor Bad Dragon's clearance section and can notify you if a toy you want is in there.

To get started, type /help for a list of commands.
EOF
      end
    end
  end
end
