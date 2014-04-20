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

  it 'should list only active chatrooms' do
    active_chatroom = create(:chatroom)
    create(:chatroom, ended_at: Time.now)

    Chatroom.active.to_a.should eq([active_chatroom])
  end

  it 'should list only inactive chatrooms' do
    create(:chatroom)
    inactive_chatroom = create(:chatroom, ended_at: Time.now)

    Chatroom.inactive.to_a.should eq([inactive_chatroom])
  end

  it 'should show the full time the chat lasted' do
    chatroom = create(:chatroom)

    first_message_time = Time.local(2011, 1, 1, 11, 1, 1)
    second_message_time = Time.local(2011, 1, 1, 12, 1, 1)

    message1 = create(:message, created_at: first_message_time)
    message2 = create(:message, created_at: second_message_time)

    chatroom.messages = [message1, message2]
    chatroom.save

    chatroom.duration.should == second_message_time - first_message_time
  end
end
