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

  describe "GET #show" do
    it "assigns a the Product to @product" do
      product = create(:product)
      get :show, id: product
      expect(assigns(:product)).to eq product
    end

    it "renders the show template" do
      product = create(:product)
      get :show, id: product
      expect(response).to render_template :show
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

  describe "GET :edit" do
    it "assigns the requested product to @product" do
      sign_in create(:admin)
      product = create(:product)

      get :edit, id: product
      expect(assigns(:product)).to eq product
    end

    it "renders the edit template" do
      sign_in create(:admin)
      product = create(:product)

      get :edit, id: product
      expect(response).to render_template :edit
    end

    it "denies access to non-admin users" do
      sign_in create(:user)
      product = create(:product)

      get :edit, id: product
      expect(response).to redirect_to new_admin_session_path
    end

    it "denies access for non-authenticated users" do
      product = create(:product)

      post :create, id: product
      expect(response).to redirect_to new_admin_session_path
    end
  end

  describe "PATCH #update" do
    before do
      @product = create(:product)
    end

    context "with valid attributes" do
      before { sign_in create(:admin) }

      it "locates the requested @product" do
        patch :update, id: @product, product: attributes_for(:product)
        expect(assigns(:product)).to eq @product
      end

      it "changes @product's attributes" do
        old_category = @product.categories.last
        other_category = create(:category)

        patch :update, id: @product,
          product:
          { title: "Ice Cream", price: 4.09, description: "A tasty treat!",
            category_ids: [other_category.id.to_s], "display_rank"=> "5" }
          @product.reload

          expect(@product.title).to eq "Ice Cream"
          expect(@product.price).to eq "4.09"
          expect(@product.description).to eq "A tasty treat!"
          expect(@product.display_rank).to eq 5
          expect(@product.categories).to include(other_category)
          expect(@product.categories).not_to include(old_category)
      end

      it "redirects to the admin dashboard path" do
        patch :update, id: @product, product: attributes_for(:product)
        expect(assigns(:product)).to eq @product
        expect(response).to redirect_to dashboard_path
      end
    end

    context "with invalid attributes" do
      before { sign_in create(:admin) }

      it "doens't change the contact's attributes" do
        old_category = @product.categories.last
        old_attributes = @product.attributes
        other_category = create(:category)

        patch :update, id: @product, product: attributes_for(:invalid_product)
        @product.reload

        expect(@product.attributes).to eq old_attributes
        expect(@product.categories).to include(old_category)
        expect(@product.categories).not_to include(other_category)
      end

      it "re-renders the edit template" do
        patch :update, id: @product, product: attributes_for(:invalid_product)
        expect(response).to render_template :edit
      end
    end

    it "denies access to non-admin users" do
      sign_in create(:user)
      product = create(:product)

      patch :update, id: product, product: attributes_for(:product)
      expect(response).to redirect_to new_admin_session_path
    end

    it "denies access for non-authenticated users" do
      product = create(:product)

      patch :update, id: product, product: attributes_for(:product)
      expect(response).to redirect_to new_admin_session_path
    end
  end

  describe "GET #retired" do

    before { sign_in create(:admin) }

    it "assigns all retired products to @products" do
      available = double("prodcut")
      retired = double("prodcut")
      Product.stub(:retired).and_return([retired])

      get :retired
      expect(assigns(:products)).to include(retired)
      expect(assigns(:products)).not_to include(available)
    end

    it "renders the :retired template" do
      get :retired
      expect(response).to render_template :retired
    end
  end
end
