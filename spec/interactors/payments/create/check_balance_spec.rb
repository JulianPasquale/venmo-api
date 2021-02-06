# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::Create::CheckBalance do
  subject(:context) { described_class.call(params) }

  describe '.call' do
    let!(:friendship) { create(:friendship) }
    let!(:params) { build(:check_balance_params, friendship: friendship) }

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'provides the sender' do
      expect(context.sender).to eq(friendship.user)
    end

    it 'provides the receiver' do
      expect(context.receiver).to eq(friendship.friend)
    end

    context 'when payment amount is greater than balance' do
      let!(:sender_account) { create(:payment_account, balance: 100) }
      let!(:friendship) { create(:friendship, user: sender_account.user) }

      let!(:params) do
        build(:check_balance_params, friendship: friendship, amount: 500)
      end

      context 'when mock transfer fails' do
        before do
          allow_any_instance_of(MoneyTransferService).to(
            receive(:transfer).and_return(false)
          )
        end

        let(:expected_errors) { ['Your funds are insufficient and transfer from bank failed'] }

        it 'fails' do
          expect(context).to be_a_failure
        end

        it 'provides expected errors' do
          expect(context.errors).to match(expected_errors)
        end

        it 'do not change account balance' do
          expect { context }.to_not(change { sender_account.reload.balance })
        end
      end

      context 'when mock transfer succeeds' do
        it 'succeeds' do
          expect(context).to be_a_success
        end

        it 'changes account balance' do
          expect { context }.to(
            change { sender_account.reload.balance }.by(params[:amount] - sender_account.balance)
          )
        end
      end
    end

    context 'when payment amount is less than balance' do
      let!(:sender_account) { create(:payment_account, balance: 500) }
      let!(:friendship) { create(:friendship, user: sender_account.user) }

      let!(:params) do
        build(:check_balance_params, friendship: friendship, amount: 100)
      end

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'do not changes account balance' do
        expect { context }.to_not(change { sender_account.reload.balance })
      end
    end
  end
end