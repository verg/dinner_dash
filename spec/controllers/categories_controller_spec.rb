require 'spec_helper'

describe CategoriesController do
  describe "GET #show" do
    it "assigns the requested category to @category" do
      category = create(:category)
      get :show, id: category
      expect(assigns(:category)).to eq category
    end

    it 'assigns the products associated with the category to @products' do
      category = create(:category)
      in_category = category.products.create(title: "Pizza", price_cents: 150 )
      not_in_category = Product.create(title: "Not Pizza", price_cents: 150 )

      get :show, id: category
      expect(assigns(:products)).to eq [in_category]
    end

    it "renders the :show template" do
      category = create(:category)
      get :show, id: category
      expect(response).to render_template :show
    end
  end
end
