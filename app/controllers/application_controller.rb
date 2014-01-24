class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_cart
    current_or_guest_user.cart || current_or_guest_user.create_cart
  end

  def current_or_guest_user
    if current_user
      log_in_and_destroy_guest_user if session[:guest_user_id]
      current_user
    else
      guest_user
    end
  end

  def guest_user
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound
    session[:guest_user_id] = nil
    guest_user
  end

  private

  def create_guest_user
    user = User.create(email: "guest_#{Time.now.to_i}#{rand(99)}@example.com")
    user.save!(validate: false)
    session[:guest_user_id] = user.id
    user
  end

  def log_in_and_destroy_guest_user
    logging_in
    guest_user.destroy
    session[:guest_user_id] = nil
  end

  def logging_in
    # assign any state from the guest user to the current user
    if cart = guest_user.cart
      cart.user_id = current_user.id
      cart.save!
    end
  end
end
