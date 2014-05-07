class Session < ActiveRecord::Base
  GIVER_SESSION_TYPE = 'giver'
  TAKER_SESSION_TYPE = 'taker'

  belongs_to :topic
  has_one :chatroom
end
