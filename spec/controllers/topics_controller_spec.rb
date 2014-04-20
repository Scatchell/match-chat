require 'spec_helper'

describe TopicsController do

  let(:valid_session) { {} }

  let(:current_user) { create(:user) }

  before { controller.stub(:authenticate_user!).and_return true }

  before { controller.stub(:current_user).and_return current_user }

  it 'should list all topics in the index route' do
    topic = create(:topic)
    topic2 = create(:topic)

    get :index, {}, valid_session

    assigns(:topics).to_a.should == [topic, topic2]
  end

  it 'should add a giver to a topic' do
    topic = create(:topic)

    get :register_giver, {id: topic.to_param}, valid_session

    givers_chatroom = Chatroom.last
    givers_chatroom.users.should == [current_user]

    response.should redirect_to(givers_chatroom)
    topic.sessions.first.chatroom.should == givers_chatroom
  end

  it 'should redirect a giver to an already existing takers chatroom if they exist' do
    topic = create(:topic)
    taker_chatroom = create(:chatroom, session: create(:session))
    topic.add_taker taker_chatroom, current_user

    second_user = create(:user)
    controller.stub(:current_user).and_return second_user

    get :register_giver, {id: topic.to_param}, valid_session

    response.should redirect_to(taker_chatroom)

    Chatroom.find(taker_chatroom.id).users.collect(&:id).sort.should == [current_user.id, second_user.id].sort
  end

  it 'should redirect a taker to an already existing givers chatroom if they exist' do
    topic = create(:topic)
    giver_chatroom = create(:chatroom)
    topic.add_giver giver_chatroom, current_user

    second_user = create(:user)
    controller.stub(:current_user).and_return second_user

    get :register_taker, {id: topic.to_param}, valid_session

    response.should redirect_to(giver_chatroom)

    Chatroom.find(giver_chatroom.id).users.collect(&:id).sort.should == [current_user.id, second_user.id].sort
  end

  it 'should redirect to the first taker if there are multiple existing' do
    topic = create(:topic)

    earliest_time = Time.local(2011, 1, 1, 11, 1, 1)
    later_time = Time.local(2011, 1, 1, 12, 1, 1)
    latest_time = Time.local(2011, 1, 1, 13, 1, 1)

    first_takers_chatroom = create(:chatroom)

    Timecop.freeze(earliest_time)
    topic.add_taker first_takers_chatroom, current_user

    Timecop.freeze(later_time)
    topic.add_taker create(:chatroom), current_user

    Timecop.freeze(latest_time)
    topic.add_taker create(:chatroom), current_user

    get :register_giver, {id: topic.to_param}, valid_session

    response.should redirect_to(first_takers_chatroom)
  end


end
