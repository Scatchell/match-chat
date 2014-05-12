require 'spec_helper'

describe Topic do
  let(:topic) { Topic.new }
  let(:user) { create(:user) }

  it 'should add givers to a list if no takers exist' do
    chatroom = create(:chatroom)
    topic.giver_has_match?.should == false

    topic.add_giver chatroom, user

    Session.last.chatroom.should eq(chatroom)
    Session.last.session_type.should eq(Session::GIVER_SESSION_TYPE)
  end

  it 'should add takers to a list if no givers exist' do
    chatroom = create(:chatroom)
    topic.taker_has_match?.should == false

    topic.add_taker(chatroom, user)

    Session.last.chatroom.should eq(chatroom)
    Session.last.session_type.should eq(Session::TAKER_SESSION_TYPE)
  end

  it 'should match and destroy a session when there is a match on a taker' do
    givers_chatroom = create(:chatroom)
    topic.giver_has_match?.should == false
    topic.add_giver givers_chatroom, user

    topic.taker_has_match?.should == true
    topic.associate_match_for_taker(stub_model(User)).should == givers_chatroom

    Session.count.should == 0
  end

  it 'should match a session when there is a match on a giver' do
    givers_chatroom = create(:chatroom)
    topic.add_taker givers_chatroom, user

    topic.giver_has_match?.should == true
    topic.associate_match_for_giver(stub_model(User), givers_chatroom.session).should == givers_chatroom
  end

  it 'should list all takers' do
    chatroom = create(:chatroom)
    topic.add_taker chatroom, user

    second_user = create(:user)
    second_chatroom = create(:chatroom)
    topic.add_taker second_chatroom, second_user

    user_that_is_not_taker = create(:user, name: 'non taker user')
    third_chatroom = create(:chatroom)
    topic.add_giver third_chatroom, user_that_is_not_taker

    topic.all_takers.should =~ [user, second_user]
  end

end
