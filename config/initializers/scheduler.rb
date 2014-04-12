require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
scheduler = Rufus::Scheduler.singleton

include HeartbeatsHelper

scheduler.every '20s' do
  Rails.logger.info 'Scheduler looking for disconnected users...'

  disconnected_users = disconnect_users
  if disconnected_users

    disconnected_users.each do |user|
      users_chatroom = user.chatroom

      if users_chatroom
        message = "<li><span class=\"created_at\">[#{Time.now.strftime('%H:%M')}]</span> #{user.name} has disconnected</li>"
        PrivatePub.publish_to('/messages/new/' + users_chatroom.id.to_s, "$('#chat').append('#{message}');")
      end
    end
  end
end