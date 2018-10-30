require "../../connection/redis"
require "../../bad_dragon/entities/toy"

require "json"

module Repository
  # The ConversationContext repository manages a conversation with the bot.
  #
  # Redis considerations
  # --------------------
  #
  # - Redis key prefix: `ddw:cc:`
  # - A redis key for the Telegram chat ID `3038326` would be e.g. `ddw:cc:3038326`
  # - The value is the JSON representation of `Entities::ConversationContext`
  # - Keys expire after 20 minutes
  class ConversationContext
    KEY_BASE = "ddw:wn"

    private macro redis_key(key)
      "#{KEY_BASE}:#{{{key}}}"
    end

    def self.add(user_id : Int64, toy : BadDragon::Entities::Toy)
      Application.logger.info "adding toy #{toy.id} (#{toy.sku}/#{toy.size}) for #{user_id} to the notified list"
      key = redis_key(user_id)

      loop do
        Application.logger.debug "[redis] WATCH #{key.inspect}"
        redis.watch(key) # optimistic locking

        notified_toys = notifications(user_id)
        notified_toys << toy.id
        notified_toys.uniq!

        Application.logger.debug "[redis] SET #{key.inspect} #{notified_toys.to_json.inspect}"
        response = redis.multi(&.set(key, notified_toys.to_json))
        break unless response.empty?
      end
    end

    def self.notifications(user_id) : Array(Int32)
      Application.logger.debug "[redis] GET #{redis_key(user_id).inspect}"

      JSON.parse(
        redis.get(redis_key(user_id)) || "[]"
      ).as_a.map(&.as_i)
    end

    def self.watching?(user_id : Int64, toy)
      notifications(user_id).includes?(toy.id)
    end

    private def self.redis
      Connection::Redis.connection
    end
  end
end
