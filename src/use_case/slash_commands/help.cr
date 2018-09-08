require "telegram_bot"

require "./base"

module UseCase
  module SlashCommands
    class Help < SlashCommands::Base
      def self.command_name
        "help"
      end

      def self.help_text
        "Displays this list of commands, duh."
      end

      def call(bot, msg, params)
        bot.reply msg, "I know the following commands:\n\n#{formatted_commands}"
      end

      private def formatted_commands
        {{ UseCase::SlashCommands::Base.subclasses }}.reject(&.help_text.empty?).map do |klass|
          "  ➢ /#{klass.command_name} - #{klass.help_text}"
        end.join("\n")
      end
    end
  end
end
