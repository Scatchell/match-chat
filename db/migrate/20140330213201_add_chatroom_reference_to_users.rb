class AddChatroomReferenceToUsers < ActiveRecord::Migration
  change_table :users do |t|
    t.belongs_to :chatroom
  end
end
