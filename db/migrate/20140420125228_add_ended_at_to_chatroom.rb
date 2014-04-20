class AddEndedAtToChatroom < ActiveRecord::Migration
  def change
    add_column :chatrooms, :ended_at, :datetime
  end
end
