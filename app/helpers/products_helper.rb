module ProductsHelper
  def render_tiled(products, columns=3)
    render 'products/tiles', products: products, columns: columns
  end

  def cache_key_for_products
    "products/all-#{count}-#{max_updated_at}"
  end

  private

  def count
    Product.count
  end

  def max_updated_at
    Product.maximum(:updated_at).try(:utc).try(:to_s, :number)
  end
end
