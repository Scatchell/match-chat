class Chatroom < ActiveRecord::Base
  has_many :messages
  has_many :users
  belongs_to :session

  def self.for_user(current_user)
    # todo how to do a rails query to achieve the following
    all.select do |chatroom|
      chatroom.users.include? current_user
    end.first
  end

  def disconnect_users
    disconnected_users = []

    users.each do |user|
      if Heartbeat.for_user(user).nil?
        disconnected_users.push user
        users.delete user
      end
    end

    disconnected_users
  end
end

