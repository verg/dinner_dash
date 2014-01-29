require 'spec_helper'

describe OrdersController do
  describe "GET #index" do
    it "populates an array of orders for the current user" do
      sign_in user = create(:user)
      orders = 2.times.map { create(:order, user: user) }

      get :index, user_id: user
      expect(assigns(:orders)).to match_array orders
    end

    it "renders the :index view" do
      sign_in user = create(:user)

      get :index, user_id: user
      expect(response).to render_template :index
    end

    it "denies access to viewing other user's orders" do
      sign_in non_admin_user = create(:user)
      other_user = create(:user)

      get :index, user_id: other_user
      expect(response).to redirect_to user_orders_path(non_admin_user)
    end

    it "denies access for non-authenticated users" do
      other_user = create(:user)

      get :index, user_id: other_user
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "GET #show" do
    it "assigns the requested order to @order" do
      sign_in user = create(:user)
      order = create(:order, user: user)

      get :show, id: order, user_id: user
      expect(assigns(:order)).to eq order
    end

    it "renders the :show template" do
      sign_in user = create(:user)
      order = create(:order, user: user)

      get :show, id: order, user_id: user
      expect(response).to render_template :show
    end
    it "denies access to viewing other user's orders" do
      sign_in non_admin_user = create(:user)
      other_user = create(:user)
      order = create(:order, user: other_user)

      get :show, id: order, user_id: other_user
      expect(response).to redirect_to user_orders_path(non_admin_user)
    end

    it "denies access for non-authenticated users" do
      other_user = create(:user)

      order = create(:order, user: other_user)
      get :show, id: order, user_id: other_user
      expect(response).to redirect_to new_user_session_path
    end
  end
end
