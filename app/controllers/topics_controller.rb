class TopicsController < ApplicationController
  before_filter :authenticate_user!

  def register_giver
    topic = Topic.find(params[:id])

    if topic.giver_has_match?
      matching_chatroom = topic.associate_match_for_giver(current_user)

      redirect_to matching_chatroom
    else
      chatroom = Chatroom.create!
      topic.add_giver chatroom, current_user
      redirect_to chatroom
    end
  end

  def register_taker
    topic = Topic.find(params[:id])

    if topic.taker_has_match?
      matching_chatroom = topic.associate_match_for_taker(current_user)

      redirect_to matching_chatroom
    else
      chatroom = Chatroom.create!
      topic.add_taker chatroom, current_user
      redirect_to chatroom
    end
  end
end
