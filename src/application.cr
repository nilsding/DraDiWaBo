require "logger"

require "./use_case/cli_commands"

class Application
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
    exit_with_usage unless UseCase::CliCommands::COMMANDS.has_key?(command)

    UseCase::CliCommands::COMMANDS[command].call(@argv)
  end

  private def exit_with_usage(status = 1)
    UseCase::PrintUsage.call
    exit status
  end
end
