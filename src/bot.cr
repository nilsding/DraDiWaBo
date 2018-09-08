require "telegram_bot"

require "./application"
require "./errors"
require "./use_case/slash_commands"

class Bot < TelegramBot::Bot
  include TelegramBot::CmdHandler

  def initialize
    @logger = Application.logger
    super("DragonDickWatchbot", ENV["TELEGRAM_API_TOKEN"])

    register_commands
  end

  def start
    logger.info "Bot is starting up"
    raise Errors::GenericError.new("Webhook is not supported yet") if ENV.has_key?("ENABLE_WEBHOOK")

    logger.info "Switching to polling mode"
    polling
  end

  private def register_commands
    {{ UseCase::SlashCommands::Base.subclasses }}.each do |klass|
      cmd klass.command_name do |msg, params|
        klass.call(self, msg, params)
      end
    end
  end
end
