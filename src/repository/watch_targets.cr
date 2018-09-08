require "../../connection/redis"
require "../../bad_dragon/size"

require "json"

module Repository
  # The WatchTargets repository manages the watchers of a certain toy/size
  # combination.
  #
  # Redis considerations
  # --------------------
  #
  # - Redis key prefix: `ddw:wt:`
  # - A redis key for the toy `rex` would be e.g. `ddw:wt:rex`
  # - The keys of that hash are the toy sizes, e.g. `extralarge`
  # - The value is a JSON array containing the Telegram user IDs
  #
  # This way, we can simply iterate over all toys, and get the watchers for a
  # given toy/size combination.
  class WatchTargets
    KEY_BASE = "ddw:wt"

    private macro redis_key(key)
      "#{KEY_BASE}:#{{{key}}}"
    end

    def self.add(user_id : Int32, toy_sku, toy_size : BadDragon::Size)
      Application.logger.info "adding watch #{toy_sku}/#{toy_size} for #{user_id}"
      key = redis_key(toy_sku)
      loop do
        Application.logger.debug "[redis] WATCH #{key.inspect}"
        redis.watch(key) # optimistic locking

        users = watchers(toy_sku, toy_size)
        users << user_id
        users.uniq!

        Application.logger.debug "[redis] HSET #{key.inspect} #{users.to_json.inspect}"
        response = redis.multi(&.hset(key, toy_size, users.to_json))
        break unless response.empty?
      end
    end

    def self.remove(user_id, toy_sku, toy_size : BadDragon::Size)
      Application.logger.info "removing watch #{toy_sku}/#{toy_size} for #{user_id}"
      key = redis_key(toy_sku)

      loop do
        redis.watch(key) # optimistic locking

        users = watchers(toy_sku, toy_size)
        users.delete(user_id)
        users.uniq!

        Application.logger.debug "[redis] HSET #{key.inspect} #{users.to_json.inspect}"
        response = redis.multi(&.hset(key, toy_size, users.to_json))
        break unless response.empty?
      end
    end

    def self.watchers(toy_sku, toy_size)
      Application.logger.debug "[redis] HGET #{redis_key(toy_sku).inspect} #{toy_size.inspect}"

      JSON.parse(
        redis.hget(redis_key(toy_sku), toy_size) || "[]"
      ).as_a.map(&.as_i)
    end

    private def self.redis
      Connection::Redis.connection
    end
  end
end
