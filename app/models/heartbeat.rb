class Heartbeat < ActiveRecord::Base
  DISCONNECT_TIME_SECONDS = 10

  has_one :user

  def self.for_user(current_user)
    # todo how to do a rails query to achieve the following
    #maybe something like: self.joins(current_user)?
    all.select do |heartbeat|
      heartbeat.user == current_user
    end.first
  end

  def self.remove_all_old_user_heartbeats
    #todo should chatroom deletion logic go directly here, or should it stay on chatroom?
    all.each do |heartbeat|
      time_since_last_heartbeat = Time.now - heartbeat.updated_at
      if time_since_last_heartbeat > DISCONNECT_TIME_SECONDS
        heartbeat.destroy
      end
    end
  end
end
