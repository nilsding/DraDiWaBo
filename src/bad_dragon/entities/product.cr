require "json"

module BadDragon
  module Entities
    # A Product represents... a product.  Who would have thought?
    class Product
      JSON.mapping(
        sku: String,
        name: String,
        type: String,
        title: String,
        furry_title: {type: String?, key: "furryTitle"}
      )

      def full_title
        furry_title || title
      end
    end
  end
end
