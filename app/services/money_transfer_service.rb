# frozen_string_literal: true

class MoneyTransferService
  attr_reader :external_payment_source, :user

  def initialize(external_payment_source, user)
    @external_payment_source = external_payment_source
    @user = user
  end

  def transfer(amount)
    external_payment_source.try(:send_money, amount)

    AccountManager.add_to_balance!(user: user, amount: amount)

    true
  end
end
