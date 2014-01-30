require 'spec_helper'

describe DashboardController do
  describe "GET #index" do
    it "assigns a new AdminDashboard object to @dashboard" do
      sign_in create(:admin)
      get :index
      expect(assigns(:dashboard)).to be_instance_of AdminDashboard
    end

    it "renders the dashboard template" do
      sign_in create(:admin)
      get :index
      expect(response).to render_template :index
    end

    it "prevents access for non-admins" do
      sign_in create(:user)
      get :index
      expect(response).to redirect_to new_admin_session_path
    end

    it "prevents access for non-authenticated users" do
      get :index
      expect(response).to redirect_to new_admin_session_path
    end
  end
end
