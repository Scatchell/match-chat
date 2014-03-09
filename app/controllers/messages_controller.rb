class MessagesController < ApplicationController
  def index
    @user = current_user
    @messages = @user.messages.all
  end

  def create
    @user = current_user
    @message = @user.messages.create!(params[:message].permit(:content))
  end
end
