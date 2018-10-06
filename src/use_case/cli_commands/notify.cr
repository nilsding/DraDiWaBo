require "./base"
require "../notify"
require "../../errors"

module UseCase
  module CliCommands
    class Notify < CliCommands::Base
      def self.command_name
        "notify"
      end

      def self.description
        "Fetches toys and notifies the watchers"
      end

      def call(_argv)
        UseCase::Notify.call
      end
    end
  end
end
