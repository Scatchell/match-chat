class HeartbeatsController < ApplicationController
  def create
    puts 'dub....'

    heartbeat_for_current_user = Heartbeat.for_user(current_user)

    if heartbeat_for_current_user
      heartbeat_for_current_user.updated_at = Time.now
      heartbeat_for_current_user.save
    else
      @heartbeat = Heartbeat.create(params[:heartbeat])
      @heartbeat.user = current_user
      @heartbeat.save
    end

    #todo put following into scheduler
    Heartbeat.remove_all_old_users

    users_chatroom = Chatroom.for_user(current_user)

    disconnected_users = users_chatroom.disconnect_users


    disconnected_users.each do |disconnected_user|
      message = "<li><span class=\"created_at\">[#{Time.now.strftime('%H:%M')}]</span>#{disconnected_user.name} has disconnected</li>"

      publish_to('/messages/new/' + users_chatroom.id.to_s, "$('#chat').append('#{message}');")
    end
    #-----------------------------------

    respond_to do |format|
      format.html { render :nothing => true }
      format.js {}
    end
  end

  def publish_to(channel, message)
    PrivatePub.publish_to channel, message
  end
end