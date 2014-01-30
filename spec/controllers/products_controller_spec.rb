require 'spec_helper'
require 'monetize/core_extensions'

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
      sign_in create(:admin)

      get :new
      expect(assigns(:product)).to be_a_new(Product)
    end

    it "renders the new product template" do
      sign_in create(:admin)

      get :new
      expect(response).to render_template :new
    end

    it "denies access to non-admin users" do
      sign_in create(:user)

      get :new
      expect(response).to redirect_to new_admin_session_path
    end

    it "denies access for non-authenticated users" do
      get :new
      expect(response).to redirect_to new_admin_session_path
    end
  end

  describe "POST #create" do
    describe "with valid attributes" do
      before { sign_in create(:admin) }

      it "saves the new product to the database" do
        expect {
          post :create, :product => product_attributes
        }.to change(Product, :count).by(1)
      end

      it "redirects to the admin dashboard" do
          post :create, :product => product_attributes
        expect(response).to redirect_to dashboard_path
      end

      def product_attributes
          { title: "Ice Cream", price: 4.09, description: "A tasty treat!",
            category_ids: ["6"], "display_rank"=> "5" }
      end
    end

    describe "with invalid attributes" do

      before { sign_in create(:admin) }

      it "doesn't save the new product to the database" do
        expect {
          post :create, product: attributes_for(:invalid_product)
        }.not_to change(Product, :count)
      end

      it "re-renders the :new template" do
        post :create, product: attributes_for(:invalid_product)
        expect(response).to render_template :new
      end
    end

    describe "without authentication" do
      it "redirects to the admin sign in page" do
        post :create, product: attributes_for(:product)
        expect(response).to redirect_to new_admin_session_path
      end
    end

    describe "as a non-admin" do
      it "redirects to the admin sign in page" do
        sign_in create(:user)
        post :create, product: attributes_for(:product)
        expect(response).to redirect_to new_admin_session_path
      end
    end
  end
end
