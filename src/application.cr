require "logger"
require "sidekiq"

require "./use_case/cli_commands"
require "./worker/*"

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

    setup_sidekiq_redis

    UseCase::CliCommands::COMMANDS[command].call(@argv)
  end

  private def setup_sidekiq_redis
    ENV["REDIS_PROVIDER"] = "SIDEKIQ_REDIS_URL"
    ENV["SIDEKIQ_REDIS_URL"] = "redis://localhost:6379/1"

    Sidekiq::Client.default_context = Sidekiq::Client::Context.new(
      Sidekiq::RedisConfig.new.new_pool, logger: self.class.logger
    )
  end

  private def exit_with_usage(status = 1)
    UseCase::PrintUsage.call
    exit status
  end
end
