require "colorize"
require "../errors"

module Commands
  abstract class Base
    def self.call(argv)
      new(argv).call
    rescue e : Errors::Base
      STDERR.print "#{e.human_name}: ".colorize(:light_red)
      STDERR.puts e.message
      exit 2
    end

    def self.description
      ""
    end

    def initialize(@argv : Array(String))
    end

    abstract def call
  end
end
