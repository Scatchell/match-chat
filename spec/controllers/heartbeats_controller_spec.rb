require 'spec_helper'

describe HeartbeatsController do
  let(:valid_attributes) { {  } }

  let(:valid_session) { {} }

  before { controller.stub(:authenticate_user!).and_return true }


  describe 'POST create' do
    let(:current_user) { User.create!({email: 'test@test.com', password: 'testtest'}) }
    before { controller.stub(:current_user).and_return current_user }

    it 'creates a new heartbeat for the current user' do
      expect {
        post :create, {:heartbeat => valid_attributes}, valid_session
      }.to change(Heartbeat, :count).by(1)

      Heartbeat.last.user.should == current_user
    end

    # it 'should update the heartbeat time for an already existing user' do
    #   Heartbeat.create!(user: current_user)
    #
    #   expect {
    #     post :create, {:heartbeat => valid_attributes}, valid_session
    #   }.to change(Heartbeat, :count).by(0)
    #
    #   Heartbeat.last.user.should == current_user
    # end
  end
end

