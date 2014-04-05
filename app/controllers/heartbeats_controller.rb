class HeartbeatsController < ApplicationController
  def create
    puts 'dub....'

    # todo how to do a rails query to achieve the following
    heartbeat_for_current_user = Heartbeat.all.select do |heartbeat|
      heartbeat.user == current_user
    end.first

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
    end
  end
end