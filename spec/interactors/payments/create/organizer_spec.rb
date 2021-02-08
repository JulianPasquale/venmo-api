# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::Create::Organizer do
  subject(:context) { described_class.call(params) }

  describe '.call' do
    context 'with valid params' do
      let!(:sender) do
        user = create(:user)
        user.payment_account.update(balance: 1000)
        user
      end
      let!(:friendship) { create(:friendship, user: sender) }
      let!(:params) do
        build(
          :create_payment_params,
          user_id: friendship.user_id,
          friend_id: friendship.friend_id
        )
      end

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'increments receiver balance' do
        expect { context }.to change { friendship.friend.reload.balance }.by(params[:amount])
      end

      it 'decrements sender balance' do
        expect { context }.to change { sender.reload.balance }.by(-params[:amount])
      end

      it 'creates a payment' do
        expect { context }.to change { Payment.count }.by(1)
        expect(Payment.last).to(
          have_attributes(params.slice(:amount, :description).merge!(
                            sender_id: params[:user_id],
                            receiver_id: params[:friend_id]
                          ))
        )
      end
    end

    context 'with invalid params' do
      let!(:friendship) { create(:friendship) }

      context 'when amount is invalid' do
        let!(:params) do
          build(
            :create_payment_params,
            user_id: friendship.user_id,
            friend_id: friendship.friend_id,
            amount: 5000
          )
        end

        it_behaves_like 'a failed validation'
      end

      context 'when user_id is not present' do
        let!(:params) do
          build(
            :create_payment_params,
            friend_id: friendship.friend_id,
            user_id: nil
          )
        end

        it_behaves_like 'a failed validation'
      end

      context 'when friend_id is not present' do
        let!(:params) do
          build(
            :create_payment_params,
            user_id: friendship.user_id,
            friend_id: nil
          )
        end

        it_behaves_like 'a failed validation'
      end

      context 'when user does not exists' do
        let!(:params) do
          build(
            :create_payment_params,
            user_id: User.last.id + 1,
            friend_id: friendship.friend_id
          )
        end

        it_behaves_like 'a failed validation'
      end

      context 'when friend does not exists' do
        let!(:params) do
          build(
            :create_payment_params,
            user_id: friendship.user_id,
            friend_id: User.last.id + 1
          )
        end

        it_behaves_like 'a failed validation'
      end
    end

    context 'when users are not friends' do
      let!(:user) { create(:user) }
      let!(:friend) { create(:user) }
      let!(:params) do
        build(
          :create_payment_params,
          user_id: user.id,
          friend_id: friend.id
        )
      end

      let(:expected_errors) do
        ['Users are not friends']
      end

      it 'fails' do
        expect(context).to be_a_failure
      end

      it 'provides error message' do
        expect(context.errors).to match(expected_errors)
      end
    end
  end
end
