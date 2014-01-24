require 'spec_helper'

describe LineItemsController do
  describe "POST #create" do
    before { request.env["HTTP_REFERER"] = "/" }

    it "creates a new line item if none exists for that user session & product" do
      expect{
        post :create, line_item: { quantity: 1 }, product_id: 1
      }.to change(LineItem, :count).by(1)
    end

    it "increments a line item count if one already exists for that user session & product" do
      cart = Cart.create
      cart.line_items.create(quantity: 1, product_id: 1)
      @controller.stub(:current_cart).and_return(cart)

      post :create, product_id: 1, line_item: { quantity: 2 }
      expect(cart.line_items.first.quantity).to eq 3
    end
  end

  describe "PATCH #update" do
    before { @line_item = create(:line_item, quantity: 1, product_id: 1) }

    it "changes the requested line_item's attribute" do
      patch :update, id: @line_item,
        line_item: attributes_for(:line_item, quantity: 2, product_id: 1)
      @line_item.reload
      expect(@line_item.quantity).to eq 2
    end

    it "re-renders the cart" do
      patch :update, id: @line_item, line_item: attributes_for(:line_item)
      expect(response).to redirect_to cart_path
    end
  end

  describe "DELETE destroy" do
    before { @line_item = create(:line_item) }

    it "deletes the line_item" do
      expect{
        delete :destroy, id: @line_item
      }.to change(LineItem, :count).by(-1)
    end

    it "re-renders the cart" do
      delete :destroy, id: @line_item
      expect(response).to redirect_to cart_path
    end
  end
end
