module Pagination
  def paginate(scope, default_per_page = Kaminari.config.default_per_page)
    collection = scope.page(params[:page]).per((params[:per_page] || default_per_page).to_i)

    current, total = collection.current_page, collection.total_pages

    {
      collection.model_name.plural => ActiveModelSerializers::SerializableResource.new(collection),
      pagination: {
        current:  current,
        previous: (current > 1 ? (current - 1) : nil),
        next:     (current >= total ? nil : (current + 1)),
        pages:    total,
        count:    collection.total_count
      }
    }
  end
end
