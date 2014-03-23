require 'spec_helper'

describe TopicList do
  let(:topic_list) { TopicList.new(Topic.new(name: 'test')) }

  it 'should add givers to a list under a certain topic' do
    user_double = double('user')
    topic_list.add_or_match_giver(user_double).should == false
    topic_list.givers.should eq([user_double])
  end

  it 'should add takers to a list under a certain topic' do
    user_double = double('user')
    topic_list.add_or_match_taker(user_double).should == false
    topic_list.takers.should eq([user_double])
  end

  it 'should match a taker with an already existing giver' do
    user_double = double('user')
    topic_list.add_or_match_giver(user_double).should == false

    second_user_double = double('user2')
    topic_list.add_or_match_taker(second_user_double).should == user_double

    topic_list.givers.should eq([])
    topic_list.takers.should eq([])
  end


  it 'should match a giver with an already existing taker' do
    user_double = double('user')
    topic_list.add_or_match_taker(user_double).should == false

    second_user_double = double('user2')
    topic_list.add_or_match_giver(second_user_double).should == user_double

    topic_list.givers.should eq([])
    topic_list.takers.should eq([])
  end
end
