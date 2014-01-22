require 'spec_helper'

describe CartsController do
  describe "GET #show" do
    it "assigns the user's cart to @cart" do
      cart = @controller.current_cart
      get :show, id: cart
      expect(assigns(:cart)).to eq cart
    end

    it "renders the :show template" do
      cart = @controller.current_cart
      get :show, id: cart
      expect(assigns(:cart)).to eq cart
    end
  end
end
