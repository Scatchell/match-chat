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

  describe 'chatroom duration' do
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

    it 'should show 0 seconds for a chat with no messages' do
      chatroom = create(:chatroom)

      chatroom.duration.should == 0
    end

    it 'should know when the first time period has elapsed' do
      first_message_time = Time.local(2011, 1, 1, 11, 0, 1)

      chatroom = create(:chatroom)

      create(:message, created_at: first_message_time, chatroom: chatroom)

      one_interval_later = Time.local(2011, 1, 1, 11, 0 + Chatroom::TIME_INTERVAL_IN_MINUTES, 1)

      create(:message, created_at: one_interval_later, chatroom: chatroom)

      chatroom.next_time_reached.should be_true

      chatroom.current_intervals_passed.should == 1
    end


    it 'should know when the next time period has not elapsed yet' do
      first_message_time = Time.local(2011, 1, 1, 11, 0, 1)

      chatroom = create(:chatroom)

      create(:message, created_at: first_message_time, chatroom: chatroom)

      half_way_to_first_interval = Time.local(2011, 1, 1, 11, 0, 31)
      create(:message, created_at: half_way_to_first_interval, chatroom: chatroom)

      chatroom.next_time_reached.should_not be_true

      chatroom.current_intervals_passed.should == 0
    end

    it 'should not think an interval has passed when half way there' do
      chatroom = create(:chatroom)

      first_message_time = Time.local(2011, 1, 1, 11, 0, 1)
      create(:message, created_at: first_message_time, chatroom: chatroom)

      one_interval_later = Time.local(2011, 1, 1, 11, 0 + Chatroom::TIME_INTERVAL_IN_MINUTES, 1)
      create(:message, created_at: one_interval_later, chatroom: chatroom)

      chatroom.next_time_reached

      one_and_a_half_intervals_later = Time.local(2011, 1, 1, 11, 0 + Chatroom::TIME_INTERVAL_IN_MINUTES, 31)
      create(:message, created_at: one_and_a_half_intervals_later, chatroom: chatroom)

      #re-query chatroom so all new messages exist
      chatroom = Chatroom.last

      chatroom.next_time_reached.should_not be_true

      chatroom.current_intervals_passed.should == 1
    end


    it 'should know when multiple time intervals have elapsed' do
      first_message_time = Time.local(2011, 1, 1, 11, 1, 1)

      chatroom = create(:chatroom)

      create(:message, created_at: first_message_time, chatroom: chatroom)

      three_intervals_later = Time.local(2011, 1, 1, 11, 1 + (Chatroom::TIME_INTERVAL_IN_MINUTES * 3), 1)

      create(:message, created_at: three_intervals_later, chatroom: chatroom)

      chatroom.next_time_reached.should be_true

      chatroom.current_intervals_passed.should == 3
    end

  end
end
