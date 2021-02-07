# frozen_string_literal: true

FactoryBot.define do
  factory :build_feed_response_params, class: Hash do
    association :user,
    page { 1 }

    initialize_with { attributes }
  end
end
