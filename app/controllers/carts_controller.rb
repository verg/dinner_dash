class CartsController < ApplicationController
  def show
    @cart = Cart.includes(line_items: [:product]).find_by(user_id: current_or_guest_user.id)
  end
end
