class Topic < ActiveRecord::Base
  has_many :sessions

  GIVER_SESSION_TYPE = 'giver'
  TAKER_SESSION_TYPE = 'taker'

  def giver_has_match?
    return session_exists_of_type(TAKER_SESSION_TYPE)
  end


  def taker_has_match?
    return session_exists_of_type(GIVER_SESSION_TYPE)
  end

  def match_for_giver
    get_first_session_of_type(TAKER_SESSION_TYPE)
  end

  def add_giver(chatroom)
    new_session = Session.create!(topic: self, chatroom: chatroom, session_type: GIVER_SESSION_TYPE)
    self.sessions.push new_session
    self.save!
  end

  def add_taker(chatroom)
    new_session = Session.create!(topic: self, chatroom: chatroom, session_type: TAKER_SESSION_TYPE)
    self.sessions.push new_session
    self.save!
  end

  def match_for_taker
    get_first_session_of_type(GIVER_SESSION_TYPE)
  end

  private
  def get_first_session_of_type(session_type)
    ordered_sessions = self.sessions.order created_at: :asc
    ordered_sessions.select { |session| session.session_type == session_type }.first
  end

  def session_exists_of_type(session_type)
    self.sessions.each do |session|
      return true if session.session_type == session_type
    end

    false
  end
end
