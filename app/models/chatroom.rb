class Chatroom < ActiveRecord::Base
  has_many :messages
  has_many :users
  belongs_to :session

  def disconnect_users
    disconnected_users = []

    users.each do |user|
      if user.heartbeat.nil?
        disconnected_users.push user
        users.delete user
      end
    end

    disconnected_users
  end
end

