require 'rails_helper'

describe TicketsController do
  context "not signed in" do
    it "should not show index to not logged users" do
      get :index
      expect(response).to redirect_to '/users/sign_in'
    end
  end

  context "signed in" do
    let(:user) { create :user }

    before do
      sign_in user
    end

    it "should show index to logged users" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
