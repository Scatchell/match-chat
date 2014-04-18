module ChatroomsHelper
  CHAT_FLASH_ALERT_TYPES = [:chat_flash]

  def users_available_for sessions, session_type
    sessions.select { |session| session.session_type == session_type }.size > 0
  end

  def frowny_face
    '<span style="color: red"> :( </span>'.html_safe
  end

  def smiley_face
    '<span style="color: green"> :) </span>'.html_safe
  end

  def bootstrap_chat_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?
      next unless CHAT_FLASH_ALERT_TYPES.include?(type)

      type = :info

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                               msg.html_safe, :class => "alert fade in alert-#{type}")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
end
