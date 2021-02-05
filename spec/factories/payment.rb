# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    sender
    receiver
    amount { Faker::Number.decimal(l_digits: 3, r_digits: 3) }

    transient do
      with_friendship { true }
    end

    before(:validate) do |params, evaluator|
      next unless evaluator.with_friendship

      Friendship.new(user: params.sender, friend: params.receiver)
    end
  end
end
