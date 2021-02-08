# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    sender
    receiver
    amount { Faker::Number.between(from: 1, to: 999) }
    description { Faker::Lorem.sentence }

    transient do
      with_friendship { true }
    end

    after(:build) do |params, evaluator|
      next unless evaluator.with_friendship

      params.sender.friends << params.receiver
    end
  end
end
