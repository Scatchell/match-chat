module PublishMessagesHelper
  def send_new_user_alert_for(user, chatroom)
    message = construct_message_for "#{user.name} has connected!</li>"

    publish_message_to_chatroom message, chatroom
  end

  def send_disconnect_alert_for(user, users_chatroom)
    message = construct_message_for "#{user.name} has disconnected</li>"

    publish_message_to_chatroom message, users_chatroom
  end

  def send_time_interval_alert_to(chatroom)
    message = construct_message_for "#{chatroom.current_intervals_passed * Chatroom::TIME_INTERVAL_IN_MINUTES} minutes have passed in this conversation"

    publish_message_to_chatroom message, chatroom
  end

  private
  def construct_message_for content
    "<li><span class=\"created_at\">[#{Time.now.strftime('%H:%M')}]</span> #{content}</li>"
  end

  def publish_message_to_chatroom message, chatroom
    PrivatePub.publish_to('/messages/new/' + chatroom.id.to_s,
                          "$('#chat').append('#{message}');")
  end

end