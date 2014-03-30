class CreateDefaultTopics < ActiveRecord::Migration
  def change
    Topic.create!(name: 'computers')
    Topic.create!(name: 'rails')
    Topic.create!(name: 'music')
  end
end
