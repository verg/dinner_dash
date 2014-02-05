module ProductsHelper
  def render_tiled(products, columns=3)
    render 'products/tiles', products: products, columns: columns
  end
end
