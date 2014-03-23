class TopicsController < ApplicationController
  def register_giver
    topic = Topic.find(params[:id])
    topic_list = topic.topic_list

    matched_chatroom_exists = topic_list.add_or_match_giver current_user
    if matched_chatroom_exists
      redirect_to matched_chatroom_exists
    else
      #todo change name so it creates a proper name (the name may not matter - maybe just an id?)
      chatroom = Chatroom.create!(name: 'another_test')
      redirect_to chatroom
    end

    #todo when first user registers for a topic, a chatroom should be created that they can wait in
  end


  def register_taker
    topic = Topic.find(params[:id])
    topic_list = topic.topic_list

    matched_user_exists = topic_list.add_or_match_taker current_user
    if matched_user_exists
      chatroom = Chatroom.create!(name: 'another_test')
      redirect_to chatroom
    end

    redirect_to waiting_user_path
  end
end
