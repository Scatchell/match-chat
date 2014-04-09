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
describe HeartbeatsHelper do
  #todo trying to get this test to work

  let(:valid_attributes) { {} }

  let(:valid_session) { {} }

  before { controller.stub(:authenticate_user!).and_return true }

  # before { controller.stub(:publish_to) }
  let(:user_with_old_updated_time) { User.create!({email: 'test2@test.com', password: 'testtest'}) }
end
