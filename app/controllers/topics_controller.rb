class TopicsController < ApplicationController
  before_action :find_topic, except: [:index]

  before_filter :authenticate_user!

  def index
    @topics = Topic.all
  end

  def register_giver
    if params[:session_id]
      takers_session = Session.find(params[:session_id])
      matching_chatroom = @topic.associate_match_for_giver(current_user, takers_session)
      takers_session.destroy!

      redirect_to chatroom_path(matching_chatroom)
    else
      if @topic.giver_has_match?
        session = @topic.first_session_of_type(Session::TAKER_SESSION_TYPE)

        matching_chatroom = @topic.associate_match_for_giver(current_user, session)

        session.destroy!

        redirect_to chatroom_path(matching_chatroom)
      else
        chatroom = @topic.create_chatroom
        @topic.add_giver chatroom, current_user
        redirect_to chatroom
      end
    end
  end

  def register_taker
    if @topic.taker_has_match?
      matching_chatroom = @topic.associate_match_for_taker(current_user)

      redirect_to matching_chatroom
    else
      chatroom_question = params[:question]
      chatroom = @topic.create_chatroom chatroom_question
      @topic.add_taker chatroom, current_user
      redirect_to chatroom_path(chatroom)
    end
  end

  def add_question

  end

  def show
    @all_takers = @topic.all_takers
  end

  private
  def find_topic
    @topic = Topic.find(params[:id])
  end
end
