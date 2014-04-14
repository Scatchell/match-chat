module ChatroomsHelper
  def users_available_for sessions, session_type
    sessions.select {|session| session.session_type == session_type}.size > 0
  end

  def frowny_face
    '<span style="color: red"> :( </span>'.html_safe
  end

  def smiley_face
    '<span style="color: green"> :) </span>'.html_safe
  end
end
