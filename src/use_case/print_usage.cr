require "./base"
require "./cli_commands"

module UseCase
  class PrintUsage < Base
    def call
      puts header
      puts commands
      puts configuration
    end

    private def header
      <<-EOF
Usage: #{PROGRAM_NAME} [command]

Commands:
EOF
    end

    private def commands
      filler_size = UseCase::CliCommands::COMMANDS.keys.map(&.size).max + 3
      UseCase::CliCommands::COMMANDS.each do |command, klass|
        filler = " " * (filler_size - command.size)
        puts ["    ", command, filler, klass.description].join("")
      end
    end

    private def configuration
      <<-EOF
Configuration is handled via the following environment variables:
    ENABLE_WEBHOOK       If set, start up a server for the webhook.
    LOG_LEVEL            The log level.
                         Allowed values: DEBUG, INFO, WARN, ERROR, FATAL
                         Default: INFO
    TELEGRAM_API_TOKEN   The API token for accessing Telegram's bot API.
    WEBHOOK_HOST         The host address for the webhook server to bind to.
                         Default: 0.0.0.0
    WEBHOOK_PORT         The port for the webhook server to bind to.
                         Default: 8080
EOF
    end
  end
end
