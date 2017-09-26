require 'rails_helper'

RSpec.describe Admin::MockupsController, type: :controller do
  it_behaves_like "an admin controller"

  describe ".index" do
    before { sign_in FactoryGirl.create(:admin) }

    it "doesn't show index" do
      get :index
      expect(response).to be_ok
      expect(response.body).to_not include "index"
    end
  end
end
