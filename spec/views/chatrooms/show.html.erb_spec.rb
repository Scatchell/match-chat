require 'spec_helper'

describe 'chatrooms/show' do
  before(:each) do
    @chatroom = assign(:chatroom, stub_model(Chatroom, {title: 'test title', description: 'test description'}))
  end



  describe 'message list rendering' do
    it 'should show room with title and description when no messages' do
      message_list = []
      @messages = assign(:messages, message_list)

      render

      rendered.should include(@chatroom.title)
    end

    it 'should show room with title, previous messages, and user name' do
      user = stub_model(User, {name: 'test user'})

      message_list = [stub_model(Message, {content: 'test message', created_at: Time.now, updated_at: Time.now, user: user})]
      assign(:messages, message_list)

      render

      rendered.should include(user.name)

      first_message = message_list.first
      rendered.should include(first_message.created_at.strftime('%H:%M'))
      rendered.should include(first_message.content)
    end
  end

  describe 'currently connected users rendering' do
    it 'should show currently connected users' do
      user = stub_model(User, {name: 'test user'})

      message_list = []
      @messages = assign(:messages, message_list)
      assign(:users, [user])

      render

      rendered.should include('Currently connected users')
      rendered.should include(user.name)
    end
  end


end
