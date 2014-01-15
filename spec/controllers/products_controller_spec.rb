require 'spec_helper'

describe ProductsController do
  it 'populates an array with all of the products' do
    mapo = create(:product, title: "Mapo Tofu")
    noodles = create(:product, title: "Dan Dan Noodles")
    get :index
    expect(assigns(:products)).to match_array([mapo, noodles])
  end

  it 'renders the index view' do
    get :index
    expect(response).to render_template :index
  end
end
