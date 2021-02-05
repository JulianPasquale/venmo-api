# frozen_string_literal: true

FactoryBot.define do
  factory :payment_account do
    user
    balance { Faker::Number.decimal(l_digits: 3, r_digits: 3) }
  end
end
