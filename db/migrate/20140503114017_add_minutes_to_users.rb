class AddMinutesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :minutes, :integer, null: false, default: 1000
  end
end