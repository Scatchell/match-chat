require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the HeartbeatHelper. For example:
#
# describe HeartbeatHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe ChatroomsHelper do
  it 'should alert when giver sessions are available' do
    session_stub = stub_model Session, session_type: Session::GIVER_SESSION_TYPE
    sessions = [session_stub]
    helper.users_available_for(sessions, Session::GIVER_SESSION_TYPE).should == true
  end

  it 'should alert when taker sessions are available' do
    session_stub = stub_model Session, session_type: Session::TAKER_SESSION_TYPE
    sessions = [session_stub]
    helper.users_available_for(sessions, Session::TAKER_SESSION_TYPE).should == true
  end

  it 'should alert when taker sessions are NOT available' do
    session_stub = stub_model Session, session_type: Session::TAKER_SESSION_TYPE
    sessions = [session_stub]
    helper.users_available_for(sessions, Session::GIVER_SESSION_TYPE).should == false
  end

  it 'should alert when giver sessions are NOT available' do
    session_stub = stub_model Session, session_type: Session::GIVER_SESSION_TYPE
    sessions = [session_stub]
    helper.users_available_for(sessions, Session::TAKER_SESSION_TYPE).should == false
  end
end
