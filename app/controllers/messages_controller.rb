class MessagesController < ApplicationController
  def index
    @chatroom = Chatroom.find(params[:chatroom_id])
    @messages = @chatroom.messages.all
  end

  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = @chatroom.messages.create(params[:message].permit(:content))
    @message.user = current_user
    @message.save
  end
end
