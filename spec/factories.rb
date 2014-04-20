FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com" }
    sequence(:name) { |n| "test_user#{n}" }
    password 'testtest'
  end

  factory :chatroom do
  end

  factory :session do
  end

  factory :topic do
    sequence(:name) { |n| "test_topic#{n}" }
  end

  factory :heartbeat do

  end

  factory :message do

  end
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
