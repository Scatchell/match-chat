module ChatroomsHelper
  def users_available_for sessions, session_type
    sessions.select {|session| session.session_type == session_type}.size > 0
  end
end
