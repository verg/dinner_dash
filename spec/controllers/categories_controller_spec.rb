require 'spec_helper'

describe CategoriesController do
  describe "GET #show" do
    it "assigns the a presenter for requested category to @dashboard" do
      category = create(:category)
      get :show, id: category
      expect(assigns(:presenter)).to be_instance_of ProductsPresenter
    end

    it "renders the :show template" do
      category = create(:category)
      get :show, id: category
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    it "assigns a new Category object to @category" do
      sign_in create(:admin)

      get :new
      expect(assigns(:category)).to be_a_new(Category)
    end

    it "renders the new category template" do
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

      it "saves the new category to the database" do
        expect {
          post :create, category: { name: "Entrees", product_ids: ['1', ''] }
        }.to change(Category, :count).by(1)
      end

      it "redirects to the admin dashboard" do
        post :create, category: { name: "Entrees", product_ids: ['1', ''] }
        expect(response).to redirect_to dashboard_path
      end
    end

    describe "with invalid attributes" do
      before { sign_in create(:admin) }
      it "doesn't save the new category to the database" do
        expect {
          post :create, category: attributes_for(:invalid_category)
        }.not_to change(Category, :count)
      end

      it "re-renders the new template" do
        post :create, category: attributes_for(:invalid_category)
        expect(response).to render_template :new
      end
    end

    it "denies access to non-admin users" do
      sign_in create(:user)

      post :create, category: attributes_for(:category)
      expect(response).to redirect_to new_admin_session_path
    end

    it "denies access for non-authenticated users" do
      post :create, category: attributes_for(:category)
      expect(response).to redirect_to new_admin_session_path
    end
  end

  describe "GET #edit" do
    it "assigns the requested category to @category" do
      sign_in create(:admin)
      category = create(:category)

      get :edit, id: category
      expect(assigns(:category)).to eq category
    end

    it "renders the edit template" do
      sign_in create(:admin)
      category = create(:category)

      get :edit, id: category
      expect(response).to render_template :edit
    end

    it "denies access to non-admin users" do
      sign_in create(:user)
      category = create(:category)

      get :edit, id: category
      expect(response).to redirect_to new_admin_session_path
    end

    it "denies access for non-authenticated users" do
      category = create(:category)

      post :create, id: category
      expect(response).to redirect_to new_admin_session_path
    end
  end

  describe "PATCH #update" do

    before do
      @product = create(:product)
      @category = @product.categories.last
    end

    context "with valid attributes" do

      before { sign_in create(:admin) }

      it "locates the requested @category" do
        patch :update, id: @category, category: attributes_for(:category)
        expect(assigns(:category)).to eq @category
      end

      it "changes @category's attributes" do
        other_product = create(:product)
        patch :update, id: @category,
          category: { name: "New Name", product_ids: [other_product.id.to_s] }

        @category.reload
        expect(@category.name).to eq "New Name"
        expect(@category.products).to match_array([other_product])
      end

      it "redirects to the admin dashboard path" do
        patch :update, id: @category, category: attributes_for(:category)
        expect(assigns(:category)).to eq @category
        expect(response).to redirect_to dashboard_path
      end
    end

    context "with invalid attributes" do

      before { sign_in create(:admin) }

      it "does not change the contact's attributes" do
        name = @category.name
        other_product = create(:product)
        patch :update, id: @category,
          category: { name: "", product_ids: [other_product.id.to_s] }

        @category.reload
        expect(@category.name).to eq name
        expect(@category.products).not_to include(other_product)
      end

      it "re-renders the edit template" do
        patch :update, id: @category, category: attributes_for(:invalid_category)
        expect(response).to render_template :edit
      end
    end

    it "denies access to non-admin users" do
      sign_in create(:user)
      category = create(:category)

      patch :update, id: category, category: attributes_for(:category)
      expect(response).to redirect_to new_admin_session_path
    end

    it "denies access for non-authenticated users" do
      category = create(:category)

      patch :update, id: category, category: attributes_for(:category)
      expect(response).to redirect_to new_admin_session_path
    end
  end
end
