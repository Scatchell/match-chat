class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :topic, index: true
      t.string :session_type

      t.timestamps
    end
  end
end
