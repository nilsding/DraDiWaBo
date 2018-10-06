module Errors
  class Base < Exception
    def human_name
      self.class.name.sub("Errors::", "").scan(/([A-Z][a-z]*)/).map(&.[1]).join(" ")
    end
  end

  class GenericError < Base; end

  class ConfigurationError < Base; end

  class HTTPError < Base; end

  class LockUnavailableError < Base; end
end
