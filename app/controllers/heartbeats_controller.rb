class HeartbeatsController < ApplicationController
  include HeartbeatsHelper
  #todo have some errors on production, user is disconnected immediatly
  #maybe try deleting dev database and starting from scratch, may be some initial heartbeat errors
  #maybe change times to be a bit longer on production?

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
    disconnected_users = disconnect_users

    if disconnected_users
      current_users_chatroom = current_user.chatroom

      disconnected_users.each do |user|
        message = "<li><span class=\"created_at\">[#{Time.now.strftime('%H:%M')}]</span>#{user.name} has disconnected</li>"
        publish_to('/messages/new/' + current_users_chatroom.id.to_s, "$('#chat').append('#{message}');")
      end
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