class Chatroom < ActiveRecord::Base
  has_many :messages
  has_many :users
  belongs_to :session
  before_destroy :destroy_sessions

  scope :active, -> { where ended_at: nil }
  scope :inactive, -> { all.where('ended_at IS NOT NULL') }

  def disconnect_users
    disconnected_users = []

    users.each do |user|
      if user.heartbeat.nil?
        disconnected_users.push user
        users.delete user
      end
    end

    disconnected_users
  end

  def duration
    return 0 if messages.empty?
    sorted_messages = messages.sort { |x, y| x.created_at <=> y.created_at }
    sorted_messages.last.created_at - sorted_messages.first.created_at
  end

  def end_at(ending_time)
    destroy_sessions
    self.ended_at = ending_time
    self.save
  end

  private
  def destroy_sessions
    session.destroy if session
  end
end

