# frozen_string_literal: true

class InsufficientFunds < StandardError; end

class NoPaymentAccount < StandardError; end

module AccountManager
  extend self

  def add_to_balance!(user:, amount:)
    account = user.payment_account
    no_payment_account!(user) if account.blank?

    balance = user.balance

    account.update!(balance: balance + amount)
  end

  def deduct_balance!(user:, amount:)
    account = user.payment_account

    no_payment_account!(user) if account.blank?

    balance = user.balance

    account.update!(balance: balance - amount)
  rescue ActiveRecord::RecordInvalid => e
    raise if e.record.errors[:balance].blank?

    raise InsufficientFunds
  end

  private

  def no_payment_account!(user)
    raise NoPaymentAccount, "User #{user} has no payment account associated"
  end
end
