require "redis"
require "redis/pooled_client"

require "../application"

module Connection
  class Redis
    def self.connection
      @@redis ||= begin
        Application.logger.info "Connecting to Redis"
        ::Redis::PooledClient.new
      end
    end
  end
end
