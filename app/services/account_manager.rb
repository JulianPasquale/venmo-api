# frozen_string_literal: true

class InsufficientFunds < StandardError; end

module AccountManager
  extend self

  def add_to_balance!(user:, amount:)
    balance = user.balance
    account = user.payment_account

    account.update!(balance: balance + amount)
  end

  def deduct_balance!(user:, amount:)
    balance = user.balance
    account = user.payment_account

    account.update!(balance: balance - amount)
  end
end
