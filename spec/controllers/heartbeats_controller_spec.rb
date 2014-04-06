require 'spec_helper'

describe HeartbeatsController do
  let(:valid_attributes) { {} }

  let(:valid_session) { {} }

  before { controller.stub(:authenticate_user!).and_return true }

  #stub to keep privatepub from throwing error
  before { controller.stub(:publish_to) }


  describe 'POST create' do
    let(:current_user) { User.create!({email: 'test@test.com', password: 'testtest'}) }
    before { controller.stub(:current_user).and_return current_user }

    before { Chatroom.create!(users: [current_user])}

    it 'creates a new heartbeat for the current user' do
      Chatroom.create!(users: [current_user])

      expect {
        post :create, {:heartbeat => valid_attributes}, valid_session
      }.to change(Heartbeat, :count).by(1)

      Heartbeat.last.user.should == current_user
    end

    it 'should update the heartbeat time for an already existing user' do
      Heartbeat.create!(user: current_user)
      heartbeat_last_updated_at = Heartbeat.last.updated_at

      expect {
        post :create, {:heartbeat => valid_attributes}, valid_session
      }.to change(Heartbeat, :count).by(0)

      Heartbeat.last.user.should == current_user
      Heartbeat.last.updated_at.should > heartbeat_last_updated_at
    end

    it 'should remove heartbeat if their heartbeat is NOT recent' do
      old_updated_time = Time.new(2011, 1, 1, 11, 11, 1, '+09:00')

      user_with_old_updated_time = User.create!({email: 'test2@test.com', password: 'testtest'})
      Heartbeat.create!(user: user_with_old_updated_time, updated_at: old_updated_time)

      post :create, {:heartbeat => valid_attributes}, valid_session

      Heartbeat.count.should == 1
      Heartbeat.first.user.should == current_user

    end

    it 'should not remove heartbeats if their heartbeat IS recent' do
      old_updated_time = Time.now

      user_with_old_updated_time = User.create!({email: 'test2@test.com', password: 'testtest'})
      Heartbeat.create!(user: user_with_old_updated_time, updated_at: old_updated_time)

      post :create, {:heartbeat => valid_attributes}, valid_session

      Heartbeat.count.should == 2
      Heartbeat.all[0].user.should == user_with_old_updated_time
      Heartbeat.all[1].user.should == current_user
    end

    xit 'should remove an existing session if the sessions only user is disconnected' do
      user_with_old_updated_time = User.create!({email: 'test2@test.com', password: 'testtest'})
      chatroom = Chatroom.create!
      session = Session.create!(session_type: Topic::GIVER_SESSION_TYPE, chatroom: chatroom, user: user_with_old_updated_time)
      topic = Topic.create! sessions: [session]

      old_updated_time = Time.now
      Heartbeat.create!(user: user_with_old_updated_time, updated_at: old_updated_time)

      post :create, {:heartbeat => valid_attributes}, valid_session

      user_with_old_updated_time.session.should == nil

      topic.sessions = []
    end
  end
end

