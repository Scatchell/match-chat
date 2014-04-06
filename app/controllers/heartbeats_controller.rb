class HeartbeatsController < ApplicationController
  def create
    puts 'dub....'

    Heartbeat.remove_all_old_users

    users_chatroom = Chatroom.for_user(current_user)

    disconnected_users = users_chatroom.disconnected_users

    disconnected_users.each do |disconnected_user|
      publish_to '/messages/new/' + users_chatroom.id.to_s do
        "$('#chat').append('#{disconnected_user.name} has disconnected :(');"
      end
    end

    heartbeat_for_current_user = Heartbeat.for_user(current_user)

    if heartbeat_for_current_user
      heartbeat_for_current_user.updated_at = Time.now
      heartbeat_for_current_user.save
    else
      @heartbeat = Heartbeat.create(params[:heartbeat])
      @heartbeat.user = current_user
      @heartbeat.save
    end

    respond_to do |format|
      format.html { render :nothing => true }
      format.js {}
    end
  end
end