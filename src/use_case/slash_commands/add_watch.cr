require "telegram_bot"

require "./base"
require "../../application"
require "../../bad_dragon/size"
require "../../repository/watch_targets"

module UseCase
  module SlashCommands
    class AddWatch < SlashCommands::Base
      def self.command_name
        "addWatch"
      end

      def self.help_arguments
        "SKU SIZE"
      end

      def self.help_text
        "Tell me which toy and size I should look for."
      end

      def call(bot, msg, params)
        return log_warning if msg.from.nil?
        return bot.reply(msg, usage) unless params.size == 2

        sku = params.shift
        size = BadDragon::Size.parse(params.shift)

        Repository::WatchTargets.add(msg.chat.id, sku, size)
        bot.reply msg, "I will notify you if there is a #{sku} in #{size} in the inventory."
      end

      private def log_warning
        Application.logger.warn "got an addWatch request using a message without a user -- ignoring"
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
