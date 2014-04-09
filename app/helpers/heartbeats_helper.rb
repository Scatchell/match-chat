module HeartbeatsHelper
  def disconnect_users
    Heartbeat.remove_all_old_user_heartbeats

    disconnected_users = []

    Chatroom.all.each do |chatroom|
      disconnected_users.push chatroom.disconnect_users

      if chatroom.users.size == 0
        chatroom.session.destroy
        chatroom.destroy
      end
    end

    disconnected_users.flatten
  end
end
