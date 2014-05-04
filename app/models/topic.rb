class Topic < ActiveRecord::Base
  has_many :sessions

  GIVER_SESSION_TYPE = 'giver'
  TAKER_SESSION_TYPE = 'taker'

  def giver_has_match?
    session_exists_of_type(TAKER_SESSION_TYPE)
  end


  def taker_has_match?
    session_exists_of_type(GIVER_SESSION_TYPE)
  end

  def associate_match_for_giver user
    session = first_session_of_type(TAKER_SESSION_TYPE)

    matching_chatroom = session.chatroom
    register_user_with_chatroom(user, matching_chatroom)

    matching_chatroom
  end

  def add_giver(chatroom, current_user)
    #todo will need to have giver/taker type on a user, to allow for changing of message colors and eventual different logic for takers/givers
    chatroom.users = [current_user]
    new_session = Session.create!(topic: self, chatroom: chatroom, session_type: GIVER_SESSION_TYPE)
    self.sessions.push new_session
    self.save!
  end

  def add_taker(chatroom, current_user)
    chatroom.users = [current_user]
    new_session = Session.create!(topic: self, chatroom: chatroom, session_type: TAKER_SESSION_TYPE)
    self.sessions.push new_session
    self.save!
  end

  def associate_match_for_taker user
    session = first_session_of_type(GIVER_SESSION_TYPE)

    matching_chatroom = session.chatroom
    register_user_with_chatroom(user, matching_chatroom)

    matching_chatroom
  end

  def create_chatroom
    Chatroom.create!(title: 'Chatroom for ' + self.name)
  end

  private
  def first_session_of_type(session_type)
    ordered_sessions = self.sessions.order created_at: :asc
    first_matching_session = ordered_sessions.select { |session| session.session_type == session_type }.first
    first_matching_session.destroy!
  end

  def session_exists_of_type(session_type)
    self.sessions.each do |session|
      return true if session.session_type == session_type
    end

    false
  end

  private
  def register_user_with_chatroom(user, matching_chatroom)
    matching_chatroom.users.push user
  end
end
