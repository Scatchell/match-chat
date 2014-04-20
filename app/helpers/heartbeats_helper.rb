module HeartbeatsHelper
  def disconnect_users
    Heartbeat.remove_all_old_user_heartbeats

    disconnected_users = []

    Chatroom.active.each do |chatroom|
      disconnected_users.push chatroom.disconnect_users

      if chatroom.users.size == 0
        chatroom.end_at Time.now
      end
    end

    Rails.logger.info disconnected_users.flatten

    disconnected_users.flatten
  end
end
