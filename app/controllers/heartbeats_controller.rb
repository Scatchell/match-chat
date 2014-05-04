class HeartbeatsController < ApplicationController
  include PublishMessagesHelper
  def create
    puts 'dub....'

    Heartbeat.create_or_update_for_user(current_user)

    current_user_chatroom = current_user.chatroom

    if current_user_chatroom.next_time_reached
      intervals_since_last_checked = current_user_chatroom.current_intervals_passed - current_user_chatroom.intervals_passed
      puts '&&&&&&&&&&&&'
      puts "subtracting #{intervals_since_last_checked.to_s} minutes from #{current_user.name}'s account"
      current_user.minutes -= intervals_since_last_checked
      current_user.save
      current_user_chatroom.update_intervals
      send_time_interval_alert_to(current_user_chatroom)
    end

    respond_to do |format|
      format.html { render :nothing => true }
      format.js {}
    end
  end
end