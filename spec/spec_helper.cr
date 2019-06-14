# mute the darn logger
require "../src/application"

class Application
  @@logger = Logger.new(nil)
end

require "minitest/autorun"
