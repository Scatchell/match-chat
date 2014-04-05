class AddSessionReferenceToChatrooms < ActiveRecord::Migration
  def change
    change_table(:chatrooms) do |t|
      t.references :session, index: true
    end
  end
end
