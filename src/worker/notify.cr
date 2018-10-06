require "sidekiq"

require "../bad_dragon/entities/toy"
require "../repository/watch_targets"
require "../repository/watch_notifications"
require "./send_notification"

module Worker
  class Notify
    include Sidekiq::Worker

    sidekiq_options do |job|
      job.queue = "notify"
    end

    def perform(toys : Array(BadDragon::Entities::Toy))
      toys.each do |toy|
        watchers = Repository::WatchTargets.watchers(toy.sku, toy.size)
        watchers.each do |watcher|
          next if Repository::WatchNotifications.watching?(watcher, toy)
          Worker::SendNotification.async.perform(watcher, toy)
        end
      end
    end
  end
end
