class CartController < ApplicationController
  def show
    @cart = Cart.includes(line_items: [:product]).
                 find_by(user_id: current_or_guest_user.id) ||
                 current_or_guest_user.create_cart
  end
end
