require "./base"
require "../application"
require "../bad_dragon/api/client"
require "../bot"
require "../repository/watch_notifications"
require "../repository/watch_targets"

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

      filtered_toys.each do |toy|
        watchers = Repository::WatchTargets.watchers(toy.sku, toy.size)
        watchers.each do |watcher|
          send_notification(watcher, toy)
        end
      end
    end

    private def send_notification(watcher, toy)
      return if Repository::WatchNotifications.watching?(watcher, toy)
      Application.logger.info "[notify] notifying #{watcher} for #{toy.sku}/#{toy.size}"
      bot = ::Bot.new
      bot.send_message(
        chat_id: watcher,
        text: "*browses the bad dragon clearance page and notices a #{toy.sku} in #{toy.size}* OwO what's this??\n\nget it while it's hot: https://bad-dragon.com/shop/clearance?sizes[]=#{toy.size.to_s.downcase}&skus[][]=#{toy.sku}"
      )
      unless toy.images.empty?
        toy.images.each do |image|
          bot.send_photo(
            chat_id: watcher,
            photo: image.full_filename
          )
        end
      end
      Repository::WatchNotifications.add(watcher, toy)
    end
  end
end
