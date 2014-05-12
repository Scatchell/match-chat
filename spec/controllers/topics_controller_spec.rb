require 'spec_helper'

describe TopicsController do

  let(:valid_session) { {} }

  let(:current_user) { create(:user) }

  before { controller.stub(:authenticate_user!).and_return true }

  before { controller.stub(:current_user).and_return current_user }

  it 'should list all topics in the index route' do
    Topic.destroy_all

    topic = create(:topic)
    topic2 = create(:topic)

    get :index, {}, valid_session

    assigns(:topics).to_a.should == [topic, topic2]
  end

  it 'should add a giver to a topic' do
    topic = create(:topic)

    post :register_giver, {id: topic.to_param}, valid_session

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

    post :register_giver, {id: topic.to_param}, valid_session

    response.should redirect_to(taker_chatroom)

    Chatroom.find(taker_chatroom.id).users.collect(&:id).sort.should == [current_user.id, second_user.id].sort
  end

  it 'should redirect a taker to an already existing givers chatroom if they exist' do
    topic = create(:topic)
    giver_chatroom = create(:chatroom)
    topic.add_giver giver_chatroom, current_user

    second_user = create(:user)
    controller.stub(:current_user).and_return second_user

    post :register_taker, {id: topic.to_param}, valid_session

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

    expect {
    post :register_giver, {id: topic.to_param}, valid_session
    }.to change(Session, :count).by(-1)

    response.should redirect_to(first_takers_chatroom)
  end

  it 'should assign all taker names correctly' do
    topic = create(:topic)

    first_user = create(:user)
    chatroom = create(:chatroom)
    topic.add_taker chatroom, first_user

    second_user = create(:user)
    second_chatroom = create(:chatroom)
    topic.add_taker second_chatroom, second_user

    user_that_is_not_taker = create(:user, name: 'non taker user')
    third_chatroom = create(:chatroom)
    topic.add_giver third_chatroom, user_that_is_not_taker

    get :show, {id: topic.id}, valid_session
    assigns(:all_takers).should =~ [first_user, second_user]
  end

  it 'should register a giver to a particular taker' do
    topic = create(:topic)

    earliest_time = Time.local(2011, 1, 1, 11, 1, 1)
    later_time = Time.local(2011, 1, 1, 12, 1, 1)
    latest_time = Time.local(2011, 1, 1, 13, 1, 1)

    second_takers_chatroom = create(:chatroom)

    Timecop.freeze(earliest_time)
    topic.add_taker create(:chatroom), current_user

    Timecop.freeze(later_time)
    topic.add_taker second_takers_chatroom, current_user
    session_for_second_taker = second_takers_chatroom.session

    Timecop.freeze(latest_time)
    topic.add_taker create(:chatroom), current_user

    expect {
      post :register_giver, {id: topic.to_param, session_id: session_for_second_taker.id}, valid_session
    }.to change(Session, :count).by(-1)

    response.should redirect_to(second_takers_chatroom)
  end

  it 'should register a taker with a specific question' do
    topic = create(:topic)

    question = 'Test question'
    post :register_taker, {id: topic.to_param, question: question}
    users_chatroom = current_user.chatroom

    users_chatroom.question.should == question
  end

end
