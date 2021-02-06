# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::Create::TransferFunds do
  let!(:sender_account) { create(:payment_account, balance: 1000) }
  let!(:receiver_account) { create(:payment_account) }

  let!(:params) do
    build(:transfer_funds_params, sender: sender_account.user, receiver: receiver_account.user)
  end

  subject(:context) { described_class.call(params) }

  context 'when sender balance is greater than amount' do
    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'increments receiver balance' do
      expect { context }.to change { receiver_account.reload.balance }.by(params[:amount])
    end

    it 'decrements sender balance' do
      expect { context }.to change { sender_account.reload.balance }.by(-params[:amount])
    end

    it 'creates a payment' do
      expect { context }.to change { Payment.count }.by(1)
      expect(Payment.last).to(
        have_attributes(params.slice(:amount, :description).merge!(
          sender_id: params[:sender].id,
          receiver_id: params[:receiver].id
        ))
      )
    end
  end

  context 'when payments accounts are missing' do
    let!(:sender) { create(:user, payment_account: nil) }
    let(:expected_errors) { ["User #{sender} has no payment account associated"] }
    let!(:params) do
      build(:transfer_funds_params, sender: sender, receiver: receiver_account.user)
    end

    it 'fails' do
      sender.payment_account.destroy!
      sender.reload
      expect(context).to be_a_failure
    end

    it 'provides expected errors' do
      sender.payment_account.destroy!
      sender.reload
      expect(context.errors).to match(expected_errors)
    end
  end

  context 'when payments accounts has insufficient funds' do
    let!(:sender_account) { create(:payment_account, balance: 10) }
    let!(:params) do
      build(
        :transfer_funds_params,
        sender: sender_account.user,
        receiver: receiver_account.user,
        amount: 50
      )
    end

    let(:expected_errors) { ['Your funds are insufficient'] }

    it 'fails' do
      expect(context).to be_a_failure
    end

    it 'provides expected errors' do
      expect(context.errors).to match(expected_errors)
    end
  end
end
