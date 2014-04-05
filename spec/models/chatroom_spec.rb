require 'spec_helper'

describe Chatroom do
  let(:chatroom) { Chatroom.create! }


  it 'should create a chatroom with a user' do
    Chatroom.all.should == [chatroom]
  end
end
