RSpec.shared_examples "an admin controller" do
  before { sign_in user }
  let(:action) { :index }
  let(:shared_params) do
    {}
  end

  context "for an admin" do
    let(:user) { FactoryGirl.create(:admin) }
    it "should be successful" do
      get action, params: shared_params
    end
  end

  context "for a user" do
    let(:user) { FactoryGirl.create(:user) }
    it "should raise an error" do
      get action, params: shared_params
      expect(response).to be_forbidden
    end
  end
end
