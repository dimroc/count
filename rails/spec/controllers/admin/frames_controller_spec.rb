require 'rails_helper'

RSpec.describe Admin::FramesController, type: :controller do
  it_behaves_like "an admin controller" do
    let!(:frame) { FactoryGirl.create(:frame) }
    let(:action) { :update }
    let(:shared_params) { { id: frame.id } }
  end
end
