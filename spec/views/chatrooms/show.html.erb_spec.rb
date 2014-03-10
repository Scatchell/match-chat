require 'spec_helper'

describe "chatrooms/show" do
  before(:each) do
    @chatroom = assign(:chatroom, stub_model(Chatroom))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
