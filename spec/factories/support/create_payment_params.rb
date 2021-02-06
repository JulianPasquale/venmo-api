# frozen_string_literal: true

FactoryBot.define do
  factory :create_payment_params, class: Hash do
    user_id { 1 }
    friend_id { 2 }
    amount { Faker::Number.between(from: 1, to: 1000) }
    description { Faker::Lorem.sentence }

    # transient do
    #   with_existing_friends { true }
    # end

    # after(:build) do |params, evaluator|
    #   next unless evaluator.with_existing_friends

    #   user = create(:user, id: params[:user_id])
    #   friend = create(:user, id: params[:friend_id])
    #   create(:friendship, user: user, friend: friend)
    # end

    initialize_with { attributes }
  end
end
