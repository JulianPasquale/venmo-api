# frozen_string_literal: true

FactoryBot.define do
  factory :check_balance_params, class: Hash do
    friendship factory: :friendship
    amount { Faker::Number.between(from: 1, to: 1000) }
    user_id { friendship.user_id }
    friend_id { friendship.friend_id }

    initialize_with { attributes }
  end
end
