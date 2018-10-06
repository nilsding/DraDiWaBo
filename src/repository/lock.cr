require "random"

require "../../connection/redis"
require "../../errors"

module Repository
  # The Lock repository manages distributed locking.
  #
  # Redis considerations
  # --------------------
  #
  # - Redis key prefix: `ddw:lock:`
  class Lock
    KEY_BASE = "ddw:lock"

    UNLOCK_SCRIPT = <<-LUA
    if redis.call("get", KEYS[1]) == ARGV[1] then
      return { redis.call("del", KEYS[1]) }
    else
      return {}
    end
LUA

    private macro redis_key(key)
      "#{KEY_BASE}:#{{{key}}}"
    end

    # timeout in seconds
    def self.lock(lock_name, timeout = 30)
      lock_key = redis_key(lock_name)
      lock_value = Random::Secure.hex(32)
      Application.logger.debug "[redis] SET #{lock_key} #{lock_value} EX #{timeout} NX"
      return lock_value if redis.set(lock_key, lock_value, ex: timeout, nx: "NX")
      raise Errors::LockUnavailableError.new("could not acquire lock #{lock_name.inspect}")
    end

    def self.lock(lock_name, timeout = 30)
      lock_value = lock(lock_name, timeout: timeout)
      yield
      unlock(lock_name, lock_value)
    end

    def self.unlock(lock_name, lock_value)
      lock_key = redis_key(lock_name)
      Application.logger.debug "[redis] EVAL #UNLOCK_SCRIPT 1 #{lock_key} #{lock_value}"
      redis.eval(UNLOCK_SCRIPT, [lock_key], [lock_value])
      true
    end

    private def self.redis
      Connection::Redis.connection
    end
  end
end
