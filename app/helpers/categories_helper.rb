module CategoriesHelper
  def cache_key_for_categories
    "categories/all-#{count}-#{max_updated_at}"
  end

  private

  def count
    Category.count
  end

  def max_updated_at
    Category.maximum(:updated_at).try(:utc).try(:to_s, :number)
  end
end
