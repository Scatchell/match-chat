class CreateDefaultTopics < ActiveRecord::Migration
  def change
    TopicBu.create!(name: 'computers')
    TopicBu.create!(name: 'rails')
    TopicBu.create!(name: 'music')
  end
end
