require 'spec_helper'

describe CategoriesController do
  describe "GET #show" do
    it "assigns the a presenter for requested category to @dashboard" do
      category = create(:category)
      get :show, id: category
      expect(assigns(:presenter)).to be_instance_of ProductsPresenter
    end

    it "renders the :show template" do
      category = create(:category)
      get :show, id: category
      expect(response).to render_template :show
    end
  end
end
