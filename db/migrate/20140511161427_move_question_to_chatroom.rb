class MoveQuestionToChatroom < ActiveRecord::Migration
  def change
    remove_column :sessions, :question
    add_column :chatrooms, :question, :string
  end
end