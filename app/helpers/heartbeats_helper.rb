module HeartbeatsHelper
  def disconnect_users
    Heartbeat.remove_all_old_user_heartbeats

    disconnected_users = []

    Chatroom.all.each do |chatroom|
      disconnected_users.push chatroom.disconnect_users

      if chatroom.users.size == 0
        if chatroom.session
          chatroom.session.destroy
        end
        chatroom.destroy
      end
    end

    Rails.logger.info disconnected_users.flatten

    disconnected_users.flatten
  end
end
