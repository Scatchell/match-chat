class AddQuestionToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :question, :string
  end
end
