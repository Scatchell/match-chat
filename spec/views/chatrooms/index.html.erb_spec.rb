require 'spec_helper'

describe "chatrooms/index" do
  before(:each) do
    assign(:chatrooms, [
      stub_model(Chatroom),
      stub_model(Chatroom)
    ])

    assign(:topics, [
      stub_model(Topic),
      stub_model(Topic)
    ])
  end

  xit "renders a list of chatrooms" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
