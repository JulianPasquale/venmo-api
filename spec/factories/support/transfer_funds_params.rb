# frozen_string_literal: true

FactoryBot.define do
  factory :transfer_funds_params, class: Hash do
    association :sender
    association :receiver
    amount { Faker::Number.between(from: 1, to: 1000) }
    description { Faker::Lorem.sentence }

    initialize_with { attributes }
  end
end
