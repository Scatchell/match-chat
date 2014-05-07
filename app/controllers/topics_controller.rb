class TopicsController < ApplicationController
  before_action :find_topic, except: [:index]

  before_filter :authenticate_user!

  def index
    @topics = Topic.all
  end

  def register_giver
    if params[:session_id]
      takers_session = Session.find(params[:session_id])
      session_question = takers_session.question
      # todo there a better way to deal with session questions? Should it be an attribute on the chatroom model instead?
      matching_chatroom = @topic.associate_match_for_giver(current_user, takers_session)

      redirect_to chatroom_path(matching_chatroom, question: session_question)
    else
      if @topic.giver_has_match?
        session = @topic.first_session_of_type(Session::TAKER_SESSION_TYPE)

        session_question = session.question

        matching_chatroom = @topic.associate_match_for_giver(current_user, session)

        redirect_to chatroom_path(matching_chatroom, question: session_question)
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
      session_question = params[:question]
      chatroom = @topic.create_chatroom
      @topic.add_taker chatroom, current_user, session_question
      redirect_to chatroom_path(chatroom, question: session_question)
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
