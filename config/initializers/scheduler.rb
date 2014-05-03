require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

include HeartbeatsHelper
include PublishMessagesHelper

scheduler.every '20s' do
  Rails.logger.info 'Scheduler looking for disconnected users...'

  disconnected_users = disconnect_users

  if disconnected_users

    disconnected_users.each do |user|
      users_chatroom = user.chatroom

      Rails.logger.info "Disconnecting user #{user.name} with id #{user.id} from chatroom with id #{users_chatroom.id}"

      if users_chatroom
        send_disconnect_alert_for(user, users_chatroom)
      end
    end
  end
end