class Heartbeat < ActiveRecord::Base
  DISCONNECT_TIME_SECONDS = 15

  has_one :user

  def self.remove_all_old_user_heartbeats
    #todo should chatroom deletion logic go directly here, or should it stay on chatroom?
    all.each do |heartbeat|
      time_since_last_heartbeat = Time.now - heartbeat.updated_at
      if time_since_last_heartbeat > DISCONNECT_TIME_SECONDS
        heartbeat.destroy
      end
    end
  end

  def self.create_or_update_for_user(current_user)
    heartbeat_for_current_user = current_user.heartbeat

    if heartbeat_for_current_user
      heartbeat_for_current_user.updated_at = Time.now
      heartbeat_for_current_user.save
    else
      @heartbeat = Heartbeat.create!
      @heartbeat.user = current_user
      @heartbeat.save
    end
  end
end
