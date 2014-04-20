class HeartbeatsController < ApplicationController
  include HeartbeatsHelper
  def create
    puts 'dub....'

    Heartbeat.create_or_update_for_user(current_user)

    current_user_chatroom = current_user.chatroom

    if current_user_chatroom.next_time_reached
      alert_chatroom_of_time_interval(current_user_chatroom)
    end

    respond_to do |format|
      format.html { render :nothing => true }
      format.js {}
    end
  end

  private
  def alert_chatroom_of_time_interval(chatroom)
    message = "<li><span class=\"created_at\">[#{Time.now.strftime('%H:%M')}]</span> #{chatroom.current_intervals_passed * Chatroom::TIME_INTERVAL_IN_MINUTES} minutes have passed in this conversation</li>"

    PrivatePub.publish_to('/messages/new/' + chatroom.id.to_s,
                          "$('#chat').append('#{message}');")
  end
end