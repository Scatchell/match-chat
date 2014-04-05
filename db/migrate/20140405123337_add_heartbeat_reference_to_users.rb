class AddHeartbeatReferenceToUsers < ActiveRecord::Migration
  change_table :users do |t|
    t.belongs_to :heartbeat
  end
end
