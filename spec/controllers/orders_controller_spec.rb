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

  describe "GET #edit" do
    it "assigns the requested order to @order" do
      sign_in create(:admin)
      order = create(:order)

      get :edit, id: order
      expect(assigns(:order)).to eq order
    end

    it "renderes the edit template" do
      sign_in create(:admin)
      order = create(:order)

      get :edit, id: order
      expect(response).to render_template :edit
    end

    it "denies access to non-admin users" do
      sign_in create(:user)
      order = create(:order)

      get :edit, id: order
      expect(response).to redirect_to new_admin_session_path
    end

    it "denies access to non-authenticated users" do
      order = create(:order)

      get :edit, id: order
      expect(response).to redirect_to new_admin_session_path
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      let(:order) { create(:order, complete: false, paid: false, canceled: false) }
      let(:line_item) { order.line_items.first }
      let(:new_quantity) { 2 }

      before { sign_in create(:admin) }

      it "locates the requested @order" do
        patch :update, id: order, order: order_attributes
        expect(assigns(:order)).to eq order
      end

      it "changes @order's attributes" do
        patch :update, id: order, order: order_attributes
        order.reload
        expect(order.canceled?).to be_true
        expect(order.paid?).to be_true
        expect(order.completed?).to be_true
      end

      it "updates line item quantities" do
        line_item = order.line_items.first
        old_quantity = line_item.quantity

        patch :update, id: order, order: order_attributes
        line_item.reload
        expect(line_item.quantity).to eq new_quantity
        expect(line_item.quantity).not_to eq old_quantity
      end

      it "redirectes to the admin dashboard path" do
        patch :update, id: order, order: order_attributes
        expect(response).to redirect_to dashboard_path
      end

      def order_attributes
        { canceled: true, paid: true, complete: true,
          line_items_attributes:
          { "0" => {"quantity" => new_quantity, "id" => line_item.id.to_s } }
        }
      end
    end

    context "with invalid attributes" do

      let(:order) { create(:order, complete: false, paid: false, canceled: false) }
      let(:line_item) { order.line_items.first }
      let(:new_quantity) { 2 }

      before { sign_in create(:admin) }

      it "doens't save the line_item's attributes if invalid" do
        line_item = order.line_items.first
        old_quantity = line_item.quantity

        patch :update, id: order, order: invalid_attributes
        line_item.reload

        expect(line_item.quantity).to eq old_quantity
      end

      it "re-renders the edit template" do
        patch :update, id: order, order: invalid_attributes
        expect(response).to render_template :edit
      end

      def invalid_attributes
        {
          canceled: true, paid: true, complete: true,
          line_items_attributes:
          { "0" => {"quantity" => -1, "id" => line_item.id.to_s } }
        }
      end
    end

    it "denies access to non-admin users" do
      sign_in create(:user)
      order = create(:order)

      get :update, id: order
      expect(response).to redirect_to new_admin_session_path
    end

    it "denies access to non-authenticated users" do
      order = create(:order)

      get :update, id: order
      expect(response).to redirect_to new_admin_session_path
    end
  end

  describe "patch #cancel" do
    it "marks the order as canceled" do
      sign_in create(:admin)
      order = create(:order, complete: true)

      patch :cancel, id: order
      order.reload
      expect(order.canceled?).to be_true
    end

    it "redirects back to the admin dashboard" do
      sign_in create(:admin)
      order = create(:order, complete: true)

      patch :cancel, id: order
      expect(response).to redirect_to dashboard_path
    end

    it "denies access to non-admin users" do
      sign_in create(:user)
      order = create(:order)

      patch :cancel, id: order
      expect(response).to redirect_to new_admin_session_path
    end

    it "denies access to non-authenticated users" do
      order = create(:order)

      patch :cancel, id: order
      expect(response).to redirect_to new_admin_session_path
    end
  end

  describe "patch #paid" do
    it "marks the order as paid" do
      sign_in create(:admin)
      order = create(:order)

      patch :paid, id: order
      order.reload
      expect(order.paid?).to be_true
    end

    it "redirects back to the admin dashboard" do
      sign_in create(:admin)
      order = create(:order)

      patch :paid, id: order
      expect(response).to redirect_to dashboard_path
    end

    it "denies access to non-admin users" do
      sign_in create(:user)
      order = create(:order)

      patch :paid, id: order
      expect(response).to redirect_to new_admin_session_path
    end

    it "denies access to non-authenticated users" do
      order = create(:order)

      patch :paid, id: order
      expect(response).to redirect_to new_admin_session_path
    end
  end

  describe "patch #complete" do
    it "marks the order as completed" do
      sign_in create(:admin)
      order = create(:order, paid: true)

      patch :complete, id: order, order: order.attributes
      order.reload
      expect(order.complete?).to be_true
    end

    it "redirects back to the admin dashboard" do
      sign_in create(:admin)
      order = create(:order,paid: true)

      patch :complete, id: order
      expect(response).to redirect_to dashboard_path
    end

    it "denies access to non-admin users" do
      sign_in create(:user)
      order = create(:order)

      patch :complete, id: order
      expect(response).to redirect_to new_admin_session_path
    end

    it "denies access to non-authenticated users" do
      order = create(:order)

      patch :complete, id: order
      expect(response).to redirect_to new_admin_session_path
    end
  end
end
