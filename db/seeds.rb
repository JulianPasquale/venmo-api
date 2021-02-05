# frozen_string_literal: true

users = 10.times.map do
  User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email
  )
end

users.each_slice(2) do |first_user, second_user|
  first_user.friends << second_user
  first_user.sended_payments << Payment.new(
    receiver: second_user,
    amount: Faker::Number.decimal(l_digits: 3, r_digits: 3)
  )

  first_user.save
end
