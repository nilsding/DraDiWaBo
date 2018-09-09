require "minitest/autorun"

# mute the darn logger
require "../src/application"

class Application
  @@logger = Logger.new(nil)
end
