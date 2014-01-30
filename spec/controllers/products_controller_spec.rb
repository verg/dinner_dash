require 'spec_helper'

describe ProductsController do
  describe "GET #index" do
    it 'populates an array with all of the products' do
      get :index
      expect(assigns(:presenter)).to be_instance_of ProductsPresenter
    end

    it 'renders the index view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
