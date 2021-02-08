# frozen_string_literal: true

# Create users with payments accounts
users = 10.times.map do
  User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    balance: 5000
  )
end

# Create friendship and payments.
# User 1 => User 2 => User 3 => ... => User n
# Payments amount are generated randomly with Faker.
users.each_slice(2) do |first_user, second_user|
  first_user.friends << second_user

  Payments::Create::TransferFunds.call(
    sender: first_user,
    receiver: second_user,
    amount: Faker::Number.between(from: 1, to: 1000),
    description: Faker::Lorem.sentence
  )

  first_user.save
end

# Creates 20 more payments for first and second user
# for pagination purpose.
users.first.payment_account.update(balance: 20_000)
20.times do
  Payments::Create::TransferFunds.call(
    sender: users.first,
    receiver: users.second,
    amount: Faker::Number.between(from: 1, to: 1000)
  )
end
