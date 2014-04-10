require 'spec_helper'

include HeartbeatsHelper

describe HeartbeatsController do

  let(:valid_attributes) { {} }

  let(:valid_session) { {} }

  before { controller.stub(:authenticate_user!).and_return true }

  before { controller.stub(:publish_to) }

  let(:current_user) { User.create!({email: 'test@test.com', password: 'testtest'}) }

  before { controller.stub(:current_user).and_return current_user }

  let(:session) { Session.create! }

  describe 'create and remove heartbeats' do
    before { Chatroom.create!(users: [current_user], session: session) }

    it 'creates a new heartbeat for the current user' do
      Chatroom.create!(users: [current_user], session: session)

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

      Heartbeat.create!(user: current_user, updated_at: Time.now)

      expect {
        disconnect_users
      }.to change(Heartbeat, :count).by -1

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
  end

  describe 'removing sessions and chatrooms' do
    it 'should remove an existing session and chatroom if the sessions only user is disconnected' do
      #todo problem: When a user disconnects and then connects again to another chatroom within the heartbeat time limit, this doesn't disconnect them
      user_with_old_updated_time = User.create!({email: 'test2@test.com', password: 'testtest'})

      controller.stub(:current_user).and_return user_with_old_updated_time

      chatroom = Chatroom.create!(users: [user_with_old_updated_time])

      #create a session for the above chatroom
      Session.create!(session_type: Topic::GIVER_SESSION_TYPE, chatroom: chatroom)

      old_updated_time = Time.new(2011, 1, 1, 11, 11, 1, '+09:00')
      Heartbeat.create!(user: user_with_old_updated_time, updated_at: old_updated_time)

      puts '1111'
      p Chatroom.all

      expect {
        disconnect_users
      }.to change(Chatroom, :count).by(-1)

      Topic.last.sessions.should == []
    end

    it 'should remove an existing session and chatroom if the user joins a different chatroom' do
      #todo problem: When a user disconnects and then connects again to another chatroom within the heartbeat time limit, this doesn't disconnect them
      chatroom = Chatroom.create!(users: [current_user])
      Session.create!(session_type: Topic::GIVER_SESSION_TYPE, chatroom: chatroom)

      #todo heartbeat needs to have a chatroom so it can be checked against current users chatroom
      Heartbeat.create!(user: current_user, updated_at: Time.now)

      #move user to second chatroom
      second_chatroom = Chatroom.create!(users: [current_user])
      current_user.chatroom.should == second_chatroom

      Heartbeat.create!(user: current_user, updated_at: Time.now)

      expect {
        disconnect_users
      }.to change(Chatroom, :count).by(-1)

      Chatroom.first.should == second_chatroom
      Chatroom.all.size.should == 1
    end
  end
end
