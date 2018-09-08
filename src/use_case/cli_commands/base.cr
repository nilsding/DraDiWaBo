require "colorize"

require "../base"
require "../../errors"

module UseCase
  module CliCommands
    abstract class Base < UseCase::Base
      def self.call(argv)
        super
      rescue e : Errors::Base
        STDERR.print "#{e.human_name}: ".colorize(:light_red)
        STDERR.puts e.message
        exit 2
      end

      def self.description
        ""
      end
    end
  end
end
