class TopicsController < ApplicationController
  before_filter :authenticate_user!

  def register_giver
    topic = Topic.find(params[:id])

    if topic.giver_has_match?
      matching_chatroom = topic.match_for_giver.chatroom

      register_user_with(matching_chatroom)

      alert_chatroom_of_new_user(matching_chatroom)

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
      matching_chatroom = topic.match_for_taker.chatroom

      register_user_with(matching_chatroom)

      alert_chatroom_of_new_user(matching_chatroom)

      redirect_to matching_chatroom
    else
      chatroom = Chatroom.create!
      topic.add_taker chatroom, current_user
      redirect_to chatroom
    end
  end

  private
  def register_user_with(matching_chatroom)
    matching_chatroom.users.push current_user
  end
end
