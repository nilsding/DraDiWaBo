require "./cli_commands/start_bot"
require "./cli_commands/help"

module UseCase
  module CliCommands
    COMMANDS = {{UseCase::CliCommands::Base.subclasses}}.map do |subclass|
      {subclass.command_name, subclass}
    end.to_h
  end
end
