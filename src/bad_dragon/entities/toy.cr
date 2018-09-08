require "json"

require "../size"

module BadDragon
  module Entities
    # A toy is a ready-made toy.
    class Toy
      JSON.mapping(
        id: Int32,
        sku: String,
        price: Int32,
        flop_reason: String,
        type: String,
        size: BadDragon::Size,
        firmness: String,
        cumtube: Int32,
        suction_cup: Int32,
        color: String,
        color_type: String,
        color1: String,
        color2: String,
        color3: String,
        original_text: String,
        original_toy_id: Int32,
        original_order_id: Int32,
        created: {type: Time, converter: Time::Format.new("%FT%T")},
        updated: {type: Time?, converter: Time::Format.new("%FT%T")},
        images: Array(Toy::Image)
      )

      class Image
        JSON.mapping(
          id: Int32,
          inventory_toy_id: {type: Int32, key: "inventoryToyId"},
          full_filename: {type: String, key: "fullFilename"},
          thumb_filename: {type: String, key: "thumbFilename"},
          created: {type: Time, converter: Time::Format.new("%FT%T")}
        )
      end
    end
  end
end
