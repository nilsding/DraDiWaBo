require "telegram_bot"

require "./base"
require "../../application"
require "../../bad_dragon/size"
require "../../repository/watch_targets"

module UseCase
  module SlashCommands
    class RemoveWatch < SlashCommands::Base
      def self.command_name
        "removeWatch"
      end

      def self.help_arguments
        "SKU SIZE"
      end

      def self.help_text
        "Already found something?  Use this command to remove a toy from your watchlist"
      end

      def call(bot, msg, params)
        return log_warning if msg.from.nil?
        return bot.reply(msg, usage) unless params.size == 2

        sku = params.shift
        size = BadDragon::Size.parse(params.shift)

        Repository::WatchTargets.remove(msg.chat.id, sku, size)
        bot.reply msg, "I will no longer notify you if there is a #{sku} in #{size} in the inventory."
      end

      private def log_warning
        Application.logger.warn "got a removeWatch request using a message without a user -- ignoring"
      end

      private def usage
        usage = <<-EOF
Usage: /#{self.class.command_name} #{self.class.help_arguments}

Parameters:
SKU - the SKU of the toy
SIZE - the size of the toy

Allowed values for SIZE:
EOF
        usage += "\n"
        usage += BadDragon::Size.values.map(&.to_s).join(", ")
      end
    end
  end
end
