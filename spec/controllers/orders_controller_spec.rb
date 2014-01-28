require 'spec_helper'

describe OrdersController do
  describe "GET #new" do
    xit "does something" do
      sign_in user = create(:user)
      get :new, user_id: user
      expect(assigns(:order)).to be_an_instance_of(Order)
    end

    xit "renders the :new template" do
      sign_in user = create(:user)
      get :new, user_id: user
      expect(response).to render_template :new
    end

    xit "denies access for non-authenticated users" do
      not_signed_in = create(:user)
      get :new, user_id: not_signed_in
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "GET #index" do
    xit "populates an array of orders for the current user" do
      sign_in user = create(:user)
      orders = 2.times.map { create(:order, user: user) }

      get :index, user_id: user
      expect(assigns(:orders)).to match_array orders
    end

    xit "renders the :index view" do
      sign_in user = create(:user)

      get :index, user_id: user
      expect(response).to render_template :index
    end

    xit "denies access to viewing other user's orders" do
      sign_in non_admin_user = create(:user)
      other_user = create(:user)

      get :index, user_id: other_user
      expect(response).to redirect_to user_orders_path(non_admin_user)
    end

    xit "denies access for non-authenticated users" do
      other_user = create(:user)

      get :index, user_id: other_user
      expect(response).to redirect_to new_user_session_path
    end
  end
end
