module Admin::SupplyItemsHelper

  def category_id_select_tag_for_supplier(supplier, selected)
    cache_key = "supplier_#{supplier.id}_categories_sorted"
    
    sorted_categories = Rails.cache.read(cache_key)
    if sorted_categories.nil?
        sorted_categories = Category.where(:supplier => supplier).sort { |a,b| a.fully_qualified_name <=> b.fully_qualified_name }
        Rails.cache.write(cache_key, sorted_categories)
    end
    
    select_tag :category_id,
      options_from_collection_for_select(sorted_categories,
      :id, :fully_qualified_name, selected),
      {:include_blank => true}
  end

end