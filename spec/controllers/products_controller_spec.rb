require 'spec_helper'

describe ProductsController do
  describe "GET #index" do
    it 'populates an array with all of the products' do
      get :index
      expect(assigns(:presenter)).to be_instance_of ProductsPresenter
    end

    it 'renders the index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #new" do
    it "assigns a new Product object to @product" do
      get :new
      expect(assigns(:product)).to be_a_new(Product)
    end

    it "renders the new product template" do

    end
  end
end
