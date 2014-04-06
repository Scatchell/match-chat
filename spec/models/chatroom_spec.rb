require 'spec_helper'

describe Chatroom do
  let(:chatroom) { Chatroom.create! }


  it 'should create a chatroom with a user' do
    Chatroom.all.should == [chatroom]
  end

  it 'should disconnect users who no longer have a heartbeat' do
    user_with_heartbeat = User.create!({email: 'test@test.com', password: 'testtest'})
    user_without_heartbeat = User.create!({email: 'test2@test.com', password: 'testtest'})

    Heartbeat.create!(user: user_with_heartbeat, updated_at: Time.now)
    chatroom.users=[user_with_heartbeat, user_without_heartbeat]
    chatroom.save

    chatroom.disconnect_users
    chatroom.users.should == [user_with_heartbeat]
  end
end
