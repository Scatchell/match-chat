require 'spec_helper'

describe Topic do
  let(:topic) { Topic.new }

  it 'should add givers to a list if no takers exist' do
    chatroom_double = double('chatroom')
    topic.giver_has_match?.should == false

    topic.add_giver chatroom_double
    topic.givers.should eq([chatroom_double])
  end

  it 'should add takers to a list if no givers exist' do
    chatroom_double = double('chatroom')
    topic.taker_has_match?.should == false

    topic.add_taker(chatroom_double)
    topic.takers.should eq([chatroom_double])
  end

  it 'should match a giver with an already existing taker' do
    chatroom_double = double('chatroom')
    topic.giver_has_match?.should == false
    topic.add_giver chatroom_double

    second_chatroom_double = double('chatroom2')
    topic.taker_has_match?.should == true
    topic.add_taker second_chatroom_double

    topic.match_for_taker.should == chatroom_double

    topic.givers.should eq([])
    topic.takers.should eq([])
  end


  it 'should match a taker with an already existing giver' do
    chatroom_double = double('chatroom')
    topic.taker_has_match?.should == false
    topic.add_taker chatroom_double

    second_chatroom_double = double('chatroom2')
    topic.giver_has_match?.should == true
    topic.add_giver second_chatroom_double

    topic.match_for_giver.should == chatroom_double

    topic.givers.should eq([])
    topic.takers.should eq([])
  end
end
