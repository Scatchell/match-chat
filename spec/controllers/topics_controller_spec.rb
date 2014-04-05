require 'spec_helper'

describe TopicsController do

  let(:valid_attributes) { {name: 'test topic'} }

  let(:valid_session) { {} }

  let(:current_user) { User.create!({email: 'test@test.com', password: 'testtest'}) }

  before { controller.stub(:authenticate_user!).and_return true }

  before { controller.stub(:current_user).and_return current_user }

  it 'should add a giver to a topic' do
    topic = Topic.create! valid_attributes

    get :register_giver, {id: topic.to_param}, valid_session

    givers_chatroom = Chatroom.last
    givers_chatroom.users.should == [current_user]

    response.should redirect_to(givers_chatroom)
    topic.sessions.first.chatroom.should == givers_chatroom
  end

  it 'should redirect a giver to an already existing takers chatroom if they exist' do
    topic = Topic.create! valid_attributes

    taker_chatroom = Chatroom.create!

    topic.add_taker taker_chatroom, current_user

    second_user = User.create!({email: 'test2@test.com', password: 'testtest'})
    controller.stub(:current_user).and_return second_user

    get :register_giver, {id: topic.to_param}, valid_session

    response.should redirect_to(taker_chatroom)

    Chatroom.find(taker_chatroom.id).users.collect(&:id).sort.should == [current_user.id, second_user.id].sort
  end

  it 'should redirect a taker to an already existing givers chatroom if they exist' do
    topic = Topic.create! valid_attributes

    giver_chatroom = Chatroom.create!
    topic.add_giver giver_chatroom, current_user

    second_user = User.create!({email: 'test2@test.com', password: 'testtest'})
    controller.stub(:current_user).and_return second_user

    get :register_taker, {id: topic.to_param}, valid_session

    response.should redirect_to(giver_chatroom)

    Chatroom.find(giver_chatroom.id).users.collect(&:id).sort.should == [current_user.id, second_user.id].sort
  end

  it 'should redirect to the first taker if there are multiple existing' do
    topic = Topic.create! valid_attributes

    first_takers_chatroom = Chatroom.create!(title: 'one')
    topic.add_taker first_takers_chatroom, current_user
    topic.add_taker Chatroom.create!(title: 'two'), current_user
    topic.add_taker Chatroom.create!(title: 'three'), current_user

    get :register_giver, {id: topic.to_param}, valid_session

    response.should redirect_to(first_takers_chatroom)
  end


end
