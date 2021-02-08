# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountManager do
  describe '.add_to_balance!' do
    let(:user) { create(:user) }
    let(:amount) { Faker::Number.between(from: 1, to: 1000) }

    subject { described_class.add_to_balance!(user: user, amount: amount) }

    context 'when user has a payment account' do
      it 'increments user balance' do
        expect { subject }.to change(user, :balance).by(amount)
      end
    end

    context 'when user has not a payment account' do
      before do
        user.payment_account.destroy!
        user.reload
      end

      it 'raises an exception' do
        expect { subject }.to raise_error(
          NoPaymentAccount,
          I18n.t(
            :no_payment_account,
            scope: %i[interactors errors],
            user: user
          )
        )
      end
    end
  end

  describe '.deduct_balance!' do
    let(:user) { create(:user) }
    let(:amount) { Faker::Number.between(from: 1, to: 1000) }

    subject { described_class.deduct_balance!(user: user, amount: amount) }

    context 'when user has a payment account and sufficient funds' do
      before do
        user.payment_account.update(balance: 1000)
        user.reload
      end

      it 'decrements user balance' do
        expect { subject }.to change(user, :balance).by(-amount)
      end
    end

    context 'when user has not a payment account' do
      before do
        user.payment_account.destroy!
        user.reload
      end

      it 'raises an exception' do
        expect { subject }.to raise_error(
          NoPaymentAccount,
          I18n.t(
            :no_payment_account,
            scope: %i[interactors errors],
            user: user
          )
        )
      end
    end

    context 'when user has insufficient funds' do
      before do
        user.payment_account.update(balance: amount - 100)
        user.reload
      end

      it 'raises an exception' do
        expect { subject }.to raise_error(InsufficientFunds)
      end
    end
  end
end
