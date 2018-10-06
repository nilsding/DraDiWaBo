require "./base"
require "../bad_dragon/api/client"
require "../repository/watch_notifications"
require "../repository/watch_targets"
require "../worker/notify"

module UseCase
  class Notify < Base
    def call
      watched_toys = fetch_watches
      toys = fetch_toys
      notify(toys, watched_toys)
    end

    private def fetch_toys
      Application.logger.info "[notify] fetching all toys"
      client = BadDragon::API::Client.new
      client.inventory_toys
    end

    private def fetch_watches
      Application.logger.info "[notify] fetching watches"
      Repository::WatchTargets.watches
    end

    private def notify(toys, watched_toys)
      filtered_toys = toys.select do |toy|
        watched_toys.has_key?(toy.sku) &&
          watched_toys[toy.sku].includes?(toy.size)
      end

      ::Worker::Notify.async.perform(filtered_toys)
    end
  end
end
