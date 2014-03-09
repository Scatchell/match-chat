class CreateChatrooms < ActiveRecord::Migration
  def change
    create_table :chatrooms do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
