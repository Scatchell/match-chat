require 'spec_helper'

describe TopicsController do

  let(:valid_attributes) { {name: 'test topic'} }

  let(:valid_session) { {} }

  before { controller.stub(:current_user).and_return double('user') }

  it 'should add a giver to a topic' do
    topic = Topic.create! valid_attributes

    get :register_giver, {:id => topic.to_param}, valid_session

    response.should redirect_to(new_giver_path(topic))
  end

end
