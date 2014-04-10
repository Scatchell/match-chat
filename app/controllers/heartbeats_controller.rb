class HeartbeatsController < ApplicationController
  include HeartbeatsHelper
  def create
    puts 'dub....'

    Heartbeat.create_or_update_for_user(current_user)

    respond_to do |format|
      format.html { render :nothing => true }
      format.js {}
    end
  end
end