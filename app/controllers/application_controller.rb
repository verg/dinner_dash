class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_or_guest_user
    if current_user
      destroy_guest_user if session[:guest_user_id]
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

  def logging_in
    # assign any state from the guest user to the current user
  end

  def create_guest_user
    user = User.create
    user.save!(validate: false)
    session[:guest_user_id] = user.id
    user
  end

  def destroy_guest_user
    logging_in
    guest_user.destroy
    session[:guest_user_id] = nil
  end
end
