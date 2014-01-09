require 'spec_helper'

describe ItemsController do
  it 'populates an array with all of the items' do
    mapo = create(:item, title: "Mapo Tofu")
    noodles = create(:item, title: "Dan Dan Noodles")
    get :index
    expect(assigns(:items)).to match_array([mapo, noodles])
  end

  it 'renders the index view' do
    get :index
    expect(response).to render_template :index
  end
end
