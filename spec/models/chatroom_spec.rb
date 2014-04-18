require 'spec_helper'

describe Chatroom do
  let(:chatroom) { create(:chatroom) }


  it 'should create a chatroom with a user' do
    Chatroom.all.should == [chatroom]
  end

  it 'should disconnect users who no longer have a heartbeat' do
    user_with_heartbeat = create(:user)
    user_without_heartbeat = create(:user)

    Heartbeat.create!(user: user_with_heartbeat, updated_at: Time.now)
    chatroom.users=[user_with_heartbeat, user_without_heartbeat]
    chatroom.save

    chatroom.disconnect_users
    chatroom.users.should == [user_with_heartbeat]
  end
end
