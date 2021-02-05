# frozen_string_literal: true

users = 10.times.map do
  User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email
  )
end

users.each_slice(2) do |first_user, second_user|
  Friendship.create(user: first_user, friend: second_user)
end
