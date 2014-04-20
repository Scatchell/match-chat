require 'spec_helper'

include HeartbeatsHelper

describe HeartbeatsController do

  let(:valid_session) { {} }

  before { controller.stub(:authenticate_user!).and_return true }

  before { controller.stub(:publish_to) }

  let(:current_user) { create(:user) }

  before { controller.stub(:current_user).and_return current_user }

  let(:session) { create(:session) }

  describe 'create and remove heartbeats' do
    before { create(:chatroom, users: [current_user], session: session) }

    it 'creates a new heartbeat for the current user' do
      create(:chatroom, users: [current_user], session: session)

      expect {
        post :create, {:heartbeat => attributes_for(:heartbeat)}, valid_session
      }.to change(Heartbeat, :count).by(1)

      Heartbeat.last.user.should == current_user
    end

    it 'should update the heartbeat time for an already existing user' do
      heartbeat_last_updated_at = Time.local(2011, 1, 1, 11, 1, 1)
      Timecop.freeze(heartbeat_last_updated_at)

      create(:heartbeat, user: current_user)

      new_updated_at_time = Time.local(2011, 1, 1, 11, 1, 1)
      Timecop.freeze(new_updated_at_time)

      expect {
        post :create, {:heartbeat => attributes_for(:heartbeat)}, valid_session
      }.to change(Heartbeat, :count).by(0)

      Heartbeat.last.user.should == current_user
      Heartbeat.last.updated_at.should == new_updated_at_time
    end

    it 'should remove heartbeat if their heartbeat is NOT recent' do
      old_updated_time = Time.new(2011, 1, 1, 11, 11, 1, '+09:00')

      user_with_old_updated_time = create(:user)
      create(:heartbeat, user: user_with_old_updated_time, updated_at: old_updated_time)

      create(:heartbeat, user: current_user, updated_at: Time.now)

      expect {
        disconnect_users
      }.to change(Heartbeat, :count).by -1

      Heartbeat.count.should == 1
      Heartbeat.first.user.should == current_user
    end

    it 'should not remove heartbeats if their heartbeat IS recent' do
      old_updated_time = Time.now

      user_with_old_updated_time = create(:user)
      create(:heartbeat, user: user_with_old_updated_time, updated_at: old_updated_time)

      post :create, {:heartbeat => attributes_for(:heartbeat)}, valid_session

      Heartbeat.count.should == 2
      Heartbeat.all[0].user.should == user_with_old_updated_time
      Heartbeat.all[1].user.should == current_user
    end
  end

  describe 'removing sessions and chatrooms' do
    it 'should remove an existing session and chatroom if the sessions only user is disconnected' do
      user_with_old_updated_time = create(:user)

      controller.stub(:current_user).and_return user_with_old_updated_time

      chatroom = create(:chatroom, users: [user_with_old_updated_time])

      #create a session for the above chatroom
      session = create(:session, session_type: Topic::GIVER_SESSION_TYPE, chatroom: chatroom)
      create(:topic, sessions: [session])

      old_updated_time = Time.new(2011, 1, 1, 11, 11, 1, '+09:00')
      create(:heartbeat, user: user_with_old_updated_time, updated_at: old_updated_time)

      expect {
        disconnect_users
      }.to change{Chatroom.active.count}.by(-1)

      Topic.last.sessions.should == []
    end

    it 'should remove an existing session and chatroom if the user joins a different chatroom' do
      chatroom = create(:chatroom, users: [current_user])
      create(:session, session_type: Topic::GIVER_SESSION_TYPE, chatroom: chatroom)

      create(:heartbeat, user: current_user, updated_at: Time.now)

      #move user to second chatroom
      second_chatroom = create(:chatroom, users: [current_user])
      current_user.chatroom.should == second_chatroom

      create(:heartbeat, user: current_user, updated_at: Time.now)

      expect {
        disconnect_users
      }.to change{Chatroom.active.count}.by(-1)

      Chatroom.active.first.should == second_chatroom
      Chatroom.active.count.should == 1
    end
  end
end
