# frozen_string_literal: true

FactoryBot.define do
  factory :build_balance_response_params, class: Hash do
    association :user
    account { user.payment_account }

    initialize_with { attributes }
  end
end
