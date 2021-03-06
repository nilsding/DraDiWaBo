require "sidekiq"

require "../application"
require "../bot"
require "../bad_dragon/entities/toy"
require "../errors"
require "../repository/lock"
require "../repository/watch_notifications"

module Worker
  class SendNotification
    include Sidekiq::Worker

    sidekiq_options do |job|
      job.queue = "send_notification"
    end

    def perform(watcher : Int64, toy : BadDragon::Entities::Toy)
      loop do
        begin
          Repository::Lock.lock("toys_#{watcher}") do
            Application.logger.info "[notify] notifying #{watcher} for #{toy.sku}/#{toy.size}"
            send_messages(watcher, toy)
            Repository::WatchNotifications.add(watcher, toy)
          end
          break
        rescue e : Errors::LockUnavailableError
          sleep 5 * rand
        end
      end
    end

    private def send_messages(watcher, toy)
      bot = ::Bot.new
      msg = bot.send_message(
        chat_id: watcher,
        text: build_text(toy)
      )
      unless toy.images.empty?
        toy.images.each do |image|
          send_photo(watcher, toy, bot, image, msg)
        end
      end
    end

    private def build_text(toy)
      [
        "*browses the bad dragon clearance page and notices a #{toy.sku} in #{toy.size}* OwO what's this??\n\nget it while it's hot: #{build_clearance_url(toy)}",
      ].tap do |a|
        a << "\n"
        a << "\nPrice: #{toy.price} USD"
        a << "\nFirmness: #{toy.firmness}" if toy.firmness
      end.compact.join("")
    end

    private def build_clearance_url(toy)
      "https://bad-dragon.com/shop/clearance?sizes[]=#{toy.size.to_s.downcase}&skus[][]=#{toy.sku}"
    end

    private def send_photo(watcher, toy, bot, image, msg)
      bot.send_photo(
        chat_id: watcher,
        photo: image.full_filename,
        disable_notification: true,
        reply_to_message_id: msg == nil ? nil : msg.not_nil!.message_id
      )
    rescue e : TelegramBot::APIException
      Application.logger.warn "[notify] Caught a #{e.class} while sending #{watcher} an image for #{toy.sku}/#{toy.size} -- image was: #{image.inspect}\n#{e.inspect_with_backtrace}"
    end
  end
end
