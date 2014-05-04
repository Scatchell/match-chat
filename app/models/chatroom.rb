class Chatroom < ActiveRecord::Base
  has_many :messages
  has_many :users
  belongs_to :session
  before_destroy :destroy_sessions

  scope :active, -> { where ended_at: nil }
  scope :inactive, -> { all.where('ended_at IS NOT NULL') }

  TIME_INTERVAL_IN_MINUTES = 1

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

  def next_time_reached
    self.intervals_passed != current_intervals_passed
  end

  def update_intervals
    Rails.logger.info "Changing intervals to: #{current_intervals_passed}"
    self.intervals_passed = current_intervals_passed
    self.save
  end

  def current_intervals_passed
    minutes_passed = duration / 60
    intervals_passed = minutes_passed / TIME_INTERVAL_IN_MINUTES
    Rails.logger.info "intervals_passed are: #{intervals_passed}"
    (intervals_passed).to_i
  end

  private
  def destroy_sessions
    session.destroy if session
  end
end

