# frozen_string_literal: true

class InsufficientFunds < StandardError; end

class NoPaymentAccount < StandardError; end

module AccountManager
  extend self

  def add_to_balance!(user:, amount:)
    balance = user.balance
    account = user.payment_account

    no_payment_account!(user) unless account.present?

    account.update!(balance: balance + amount)
  end

  def deduct_balance!(user:, amount:)
    balance = user.balance
    account = user.payment_account

    no_payment_account!(user) unless account.present?

    account.update!(balance: balance - amount)
  rescue ActiveRecord::RecordInvalid => e
    raise unless e.record.errors[:balance].present?

    raise InsufficientFunds
  end

  private

  def no_payment_account!(user)
    raise NoPaymentAccount, "User #{user} has no payment account associated"
  end
end
