class Heartbeat < ActiveRecord::Base
  has_one :user
end
