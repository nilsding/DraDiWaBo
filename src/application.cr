require "logger"

require "./use_case/cli_commands/start_bot"

class Application
  COMMANDS = {
    "start" => UseCase::CliCommands::StartBot
  }

  def self.run(argv)
    new(argv.dup).run
  end

  def self.logger
    @@logger ||= Logger.new(
      STDOUT, level: Logger::Severity.parse(ENV.fetch("LOG_LEVEL", "INFO"))
    )
  end

  def initialize(@argv : Array(String))
  end

  def run
    exit_with_usage if @argv.empty?

    command = @argv.shift.downcase.strip
    exit_with_usage unless COMMANDS.has_key?(command)

    COMMANDS[command].call(@argv)
  end

  private def exit_with_usage(status = 1)
    usage
    exit status
  end

  private def usage
    puts <<-EOF
Usage: #{PROGRAM_NAME} [command]

Commands:
EOF
    filler_size = COMMANDS.keys.map(&.size).max + 3
    COMMANDS.each do |command, klass|
      filler = " " * (filler_size - command.size)
      puts ["    ", command, filler, klass.description].join("")
    end
    puts <<-EOF

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
