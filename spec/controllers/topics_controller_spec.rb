require 'spec_helper'

describe TopicsController do

  let(:valid_attributes) { {name: 'test topic'} }

  let(:valid_session) { {} }

  before { controller.stub(:current_user).and_return double('user') }

  it 'should add a giver to a topic' do
    topic = Topic.create! valid_attributes

    get :register_giver, {id: topic.to_param}, valid_session

    response.should redirect_to(Chatroom.last)
    topic.sessions.first.chatroom.should == Chatroom.last
  end

  it 'should redirect a giver to an already existing takers chatroom if they exist' do
    topic = Topic.create! valid_attributes

    takers_chatroom = Chatroom.create!
    topic.add_taker takers_chatroom

    get :register_giver, {id: topic.to_param}, valid_session

    response.should redirect_to(takers_chatroom)
  end

  it 'should redirect a taker to an already existing givers chatroom if they exist' do
    topic = Topic.create! valid_attributes

    giver_chatroom = Chatroom.create!
    topic.add_giver giver_chatroom

    get :register_taker, {id: topic.to_param}, valid_session

    response.should redirect_to(giver_chatroom)
  end

  it 'should redirect to the first taker if there are multiple existing' do
    topic = Topic.create! valid_attributes

    first_takers_chatroom = Chatroom.create!(title: 'one')
    topic.add_taker first_takers_chatroom
    topic.add_taker Chatroom.create!(title: 'two')
    topic.add_taker Chatroom.create!(title: 'three')

    get :register_giver, {id: topic.to_param}, valid_session

    response.should redirect_to(first_takers_chatroom)
  end


end
