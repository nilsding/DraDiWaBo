require "crest"

require "../../../application"
require "../../../errors"
require "../entities/product"
require "../entities/toy"
require "./paginated_response"

module BadDragon
  module API
    class Client
      API_BASE = "https://bad-dragon.com/api"

      def initialize(@api_base = API_BASE)
        @api = Crest::Resource.new(@api_base)
      end

      # performs a GET /products request
      # @return (BadDragon::Entity::Product)
      def products
        response = @api["/products"].get
        Array(BadDragon::Entities::Product).from_json(response.body)
      rescue Crest::RequestFailed
        raise Errors::HTTPError.new("HTTP request failed")
      end

      def inventory_toys
        fetch_inventory_toys
      end

      private def fetch_inventory_toys(page = 1)
        Application.logger.debug("fetching inventory toys - page #{page}")
        response = @api["/inventory-toys"].get(
          params: {
            :limit            => 60,
            :page             => page,
            "sort[field]"     => "created",
            "sort[direction]" => "desc",
            "price[min]"      => 0,
            "price[max]"      => 300,
          }
        )
        paginated_response = PaginatedResponse::Toys.from_json(response.body)
        return [] of BadDragon::Entities::Toy if paginated_response.toys.empty?
        paginated_response.toys + fetch_inventory_toys(page + 1)
      rescue e : Crest::RequestFailed
        raise Errors::HTTPError.new("HTTP request failed", cause: e)
      end
    end
  end
end
