require 'spec_helper'

describe Topic do
  let(:topic) { Topic.new }

  it 'should add givers to a list if no takers exist' do
    chatroom = Chatroom.create!
    topic.giver_has_match?.should == false

    topic.add_giver chatroom

    Session.last.chatroom.should eq(chatroom)
    Session.last.session_type.should eq(Topic::GIVER_SESSION_TYPE)
  end

  it 'should add takers to a list if no givers exist' do
    chatroom = Chatroom.create!
    topic.taker_has_match?.should == false

    topic.add_taker(chatroom)

    Session.last.chatroom.should eq(chatroom)
    Session.last.session_type.should eq(Topic::TAKER_SESSION_TYPE)
  end

  it 'should match and destroy a session when there is a match on a taker' do
    givers_chatroom = Chatroom.create!
    topic.giver_has_match?.should == false
    topic.add_giver givers_chatroom

    topic.taker_has_match?.should == true
    topic.match_for_taker.chatroom.should == givers_chatroom

    Session.count.should == 0
  end

  it 'should match and destroy a session when there is a match on a giver' do
    givers_chatroom = Chatroom.create!
    topic.taker_has_match?.should == false
    topic.add_taker givers_chatroom

    topic.giver_has_match?.should == true
    topic.match_for_giver.chatroom.should == givers_chatroom

    Session.count.should == 0
  end

end
