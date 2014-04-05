require 'spec_helper'

describe "Chatrooms" do
  describe "GET /chatrooms" do
    it 'should contain both users in chatroom' do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      post new_chatroom_path
      response.status.should be(200)
    end
  end
end
