class HeartbeatsController < ApplicationController
  def create
    puts 'dub....'

    @heartbeat = Heartbeat.create(params[:heartbeat])
    @heartbeat.user = current_user
    @heartbeat.save

    respond_to do |format|
      format.html { render :nothing => true }
    end
  end
end