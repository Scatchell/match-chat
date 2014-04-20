class AddIntervalsPassedToChatroom < ActiveRecord::Migration
  def change
    add_column :chatrooms, :intervals_passed, :integer, null: false, default: 0
  end
end
