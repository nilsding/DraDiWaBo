require "json"

require "../entities/toy"

module BadDragon
  module API
    module PaginatedResponse
      private macro paginated_response_class(array_name, array_type)
        class {{ array_name.capitalize.id }}
          JSON.mapping(
            page: Int32,
            limit: Int32,
            size: Int32,
            total: Int32,
            totalPages: Int32,
            {{ array_name }}: Array({{ array_type }})
          )
        end
      end

      paginated_response_class "toys", BadDragon::Entities::Toy
    end
  end
end
