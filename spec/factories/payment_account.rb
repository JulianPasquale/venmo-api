# frozen_string_literal: true

FactoryBot.define do
  factory :payment_account do
    user
    balance { Faker::Number.between(from: 1, to: 1000) }
  end
end
