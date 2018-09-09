require "../spec_helper"

require "../../src/connection/redis"
require "../../src/repository/watch_targets"

module Repository
  class WatchTargetsTest < Minitest::Test
    def test_add
      redis.hset "ddw:wt:nova", "Extralarge", "[420]"
      Repository::WatchTargets.add(1337, "nova", BadDragon::Size::Extralarge)

      users = JSON.parse(redis.hget("ddw:wt:nova", "Extralarge") || "[]").as_a.map(&.as_i)
      assert_equal [420, 1337], users
    end

    def test_add_same_user
      redis.hset "ddw:wt:nova", "Extralarge", "[420, 1337]"
      Repository::WatchTargets.add(1337, "nova", BadDragon::Size::Extralarge)

      users = JSON.parse(redis.hget("ddw:wt:nova", "Extralarge") || "[]").as_a.map(&.as_i)
      assert_equal [420, 1337], users
    end

    def test_add_nonexistent_key
      redis.del "ddw:wt:nova"
      Repository::WatchTargets.add(1337, "nova", BadDragon::Size::Extralarge)

      users = JSON.parse(redis.hget("ddw:wt:nova", "Extralarge") || "[]").as_a.map(&.as_i)
      assert_equal [1337], users
    end

    def test_remove
      redis.hset "ddw:wt:nova", "Extralarge", "[1337, 69, 420]"
      Repository::WatchTargets.remove(69, "nova", BadDragon::Size::Extralarge)

      users = JSON.parse(redis.hget("ddw:wt:nova", "Extralarge") || "[]").as_a.map(&.as_i)
      assert_equal [1337, 420], users
    end

    def test_remove_nonexistent_user
      redis.hset "ddw:wt:nova", "Extralarge", "[1337, 69, 420]"
      Repository::WatchTargets.remove(666, "nova", BadDragon::Size::Extralarge)

      users = JSON.parse(redis.hget("ddw:wt:nova", "Extralarge") || "[]").as_a.map(&.as_i)
      assert_equal [1337, 69, 420], users
    end

    def test_remove_nonexistent_key
      redis.del "ddw:wt:nova"
      Repository::WatchTargets.remove(1337, "nova", BadDragon::Size::Extralarge)

      redis_response = redis.hget("ddw:wt:nova", "Extralarge")
      assert_equal "[]", redis_response
    end

    def test_watchers
      redis.hset "ddw:wt:nova", "Extralarge", "[1337, 69, 420]"

      users = Repository::WatchTargets.watchers("nova", BadDragon::Size::Extralarge)
      assert_equal [1337, 69, 420], users
    end

    def test_watchers_nonexistent_key
      redis.del "ddw:wt:nova"

      users = Repository::WatchTargets.watchers("nova", BadDragon::Size::Extralarge)
      assert_equal [] of Int32, users
    end

    private def redis
      ::Connection::Redis.connection
    end
  end
end
