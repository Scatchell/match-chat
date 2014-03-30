class Session < ActiveRecord::Base
  belongs_to :topic
  has_one :chatroom
end
