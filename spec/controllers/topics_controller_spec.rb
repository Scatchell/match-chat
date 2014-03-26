require 'spec_helper'

describe TopicsController do

  let(:valid_attributes) { {name: 'test topic'} }

  let(:valid_session) { {} }

  before { controller.stub(:current_user).and_return double('user') }

  it 'should add a giver to a topic' do
    topic = Topic.create! valid_attributes

    get :register_giver, {id: topic.to_param}, valid_session

    response.should redirect_to(Chatroom.last)
  end

  it 'should redirect a giver to an already existing takers chatroom if they exist' do
    topic = Topic.create! valid_attributes

    get :register_taker, {id: topic.to_param}, valid_session

    takers_chatroom = Chatroom.last

    get :register_giver, {id: topic.to_param}, valid_session

    response.should redirect_to(takers_chatroom)
  end

end
