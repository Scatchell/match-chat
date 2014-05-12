require 'spec_helper'

describe 'topics/show' do
  before(:each) do
    @topic = create(:topic, name: 'test_topic')
  end

  describe 'user list rendering' do
    it 'should show taker name and associated question if question exists' do
      session = create(:session)
      question = 'test_question'
      chatroom = create(:chatroom, question: question, session: session)
      user = create(:user, name: 'test_user', chatroom: chatroom)
      @all_takers = [user]

      render

      rendered.should include(@topic.name.capitalize)
      rendered.should include(user.name)
      rendered.should include(question)
    end

    it 'should show taker name and no question available message if question does not exist' do
      session = create(:session)
      chatroom = create(:chatroom, session: session)
      user = create(:user, name: 'test_user', chatroom: chatroom)
      @all_takers = [user]

      render

      rendered.should include(@topic.name.capitalize)
      rendered.should include(user.name)
      rendered.should include('No question entered')
    end
  end
end
