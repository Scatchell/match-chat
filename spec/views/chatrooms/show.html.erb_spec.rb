require 'spec_helper'

describe 'chatrooms/show' do
  before(:each) do
    @chatroom = assign(:chatroom, stub_model(Chatroom, {title: 'test'}))
  end

  it 'should not allow user to see show page without logging in' do
    render

    rendered.should include('test')
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
