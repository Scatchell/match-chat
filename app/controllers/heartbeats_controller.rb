class HeartbeatsController < ApplicationController
  include PublishMessagesHelper
  def create
    puts 'dub....'

    Heartbeat.create_or_update_for_user(current_user)

    current_user_chatroom = current_user.chatroom

    if current_user_chatroom.next_time_reached
      send_time_interval_alert_to(current_user_chatroom)
    end

    respond_to do |format|
      format.html { render :nothing => true }
      format.js {}
    end
  end
end