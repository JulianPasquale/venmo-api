# frozen_string_literal: true

FactoryBot.define do
  factory :create_payment_params, class: Hash do
    user_id { 1 }
    friend_id { 2 }
    amount { Faker::Number.between(from: 1, to: 999) }
    description { Faker::Lorem.sentence }

    initialize_with { attributes }
  end
end
