# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:friend, :sender, :receiver] do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
  end
end
