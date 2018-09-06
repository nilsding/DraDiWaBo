require "telegram_bot"

require "./application"
require "./errors"
require "./use_case/slash_commands/start"
require "./use_case/slash_commands/help"

class Bot < TelegramBot::Bot
  include TelegramBot::CmdHandler

  macro register_command(name)
    cmd "{{ name }}" do |msg, params|
      UseCase::SlashCommands::{{ name.name.capitalize }}.call(self, msg, params)
    end
  end

  def initialize
    @logger = Application.logger
    super("DragonDickWatchbot", ENV["TELEGRAM_API_TOKEN"])

    register_command start
    register_command help
  end

  def start
    logger.info "Bot is starting up"
    raise Errors::GenericError.new("Webhook is not supported yet") if ENV.has_key?("ENABLE_WEBHOOK")

    logger.info "Switching to polling mode"
    polling
  end
end
