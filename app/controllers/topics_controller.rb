class TopicsController < ApplicationController
  def register_giver
    topic = Topic.find(params[:id])

    if topic.giver_has_match?
      redirect_to topic.match_for_giver.chatroom
    else
      chatroom = Chatroom.create!
      topic.add_giver chatroom
      redirect_to chatroom
    end
  end


  def register_taker
    topic = Topic.find(params[:id])

    if topic.taker_has_match?
      redirect_to topic.match_for_taker.chatroom
    else
      chatroom = Chatroom.create!
      topic.add_taker chatroom
      redirect_to chatroom
    end
  end
end
