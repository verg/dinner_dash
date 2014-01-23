require_relative "../../app/models/products_presenter"
require 'spec_helper'

describe ProductsPresenter do
  describe "presenting for a single category" do
    it "displays only products for that category" do
      category = build_stubbed(:category)
      product = build_stubbed(:product)
      Category.stub(:find) { category }
      category.stub(:products) { product }

      presenter = ProductsPresenter.for(category.id, cart)
      expect(presenter.categories).to eq category
      expect(presenter.products).to eq product

      expect(presenter.cart).to eq cart
    end
  end

  describe "presenting for all categories" do
    it "displays all products" do
      category_a = build_stubbed(:category)
      category_b = build_stubbed(:category)
      product_a = build_stubbed(:product)
      product_b = build_stubbed(:product)
      Category.stub(:all) { [category_a, category_b] }
      Product.stub(:available) { [product_a, product_b ] }

      presenter = ProductsPresenter.new(cart)
      expect(presenter.categories).to include(category_a, category_b)
      expect(presenter.products).to include(product_a, product_b)

      expect(presenter.cart).to eq cart
    end
  end

  describe "#cart_size_string" do
    it "returns the pluralized item count" do
      product = create(:product)
      cart = Cart.create
      cart.add_product(product.id, 2)

      presenter = ProductsPresenter.new(cart)
      expect(presenter.cart_size_string).to eq "2 Items"
    end

    it "returns the singular item count" do
      product = create(:product)
      cart = Cart.create
      cart.add_product(product.id)

      presenter = ProductsPresenter.new(cart)
      expect(presenter.cart_size_string).to eq "1 Item"
    end
  end

  describe "#cart_price" do
    it "returns the total price for the cart" do
      cart = Cart.create
      price = double("price")
      cart.stub(:total_price) { price }

      presenter = ProductsPresenter.new(cart)
      expect(presenter.total_price).to eq price
    end
  end

  def cart
    @cart ||= Cart.new
  end
end
