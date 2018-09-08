require "./base"
require "../../../bad_dragon/api/client"

module UseCase
  module CliCommands
    class Debug < CliCommands::Base
      def self.command_name
        "debug"
      end

      def self.description
        "Whatever I'm currently debugging/testing. (non-release builds only)"
      end

      def call(_argv)
        client = BadDragon::API::Client.new
        toys = client.inventory_toys
        pp toys.map(&.type).uniq
        pp toys.map(&.size).uniq
        products = client.products
        pp products.map(&.type).uniq
      rescue e
        puts e.cause
        puts e.cause.as(Crest::RequestFailed).response.body
        puts e.cause.as(Crest::RequestFailed).response.request.url
        raise e
      end
    end
  end
end
