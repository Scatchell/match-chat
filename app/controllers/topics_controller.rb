class TopicsController < ApplicationController
  def register_giver
    topic = Topic.find(params[:id])

    if topic.giver_has_match?
      redirect_to topic.match_for_giver
    else
      #todo change name so it creates a proper name (the name may not matter - maybe just an id?)
      chatroom = Chatroom.create!(title: 'another_test')
      topic.add_giver chatroom
      redirect_to chatroom
    end
  end


  def register_taker
    topic = Topic.find(params[:id])

    if topic.taker_has_match?
      redirect_to topic.match_for_taker
    else
      chatroom = Chatroom.create!(title: 'another_test')
      topic.add_taker chatroom
      redirect_to chatroom
    end
  end
end
