# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validators::CreatePaymentParams do
  describe '#valid?' do
    let!(:user) { create(:user) }
    let!(:friend) { create(:user) }
    subject { described_class.new(params) }

    context 'with valid params' do
      let!(:params) do
        build(
          :create_payment_params,
          user_id: user.id,
          friend_id: friend.id
        )
      end

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'with invalid params' do
      context 'when amount is invalid' do
        let!(:params) do
          build(
            :create_payment_params,
            user_id: user.id,
            friend_id: friend.id,
            amount: 5000
          )
        end

        it_behaves_like 'an invalid parameter', :amount
      end

      context 'when user_id is not present' do
        let!(:params) do
          build(
            :create_payment_params,
            friend_id: friend.id,
            user_id: nil
          )
        end

        it_behaves_like 'an invalid parameter', :user_id
      end

      context 'when friend_id is not present' do
        let!(:params) do
          build(
            :create_payment_params,
            user_id: user.id,
            friend_id: nil
          )
        end

        it_behaves_like 'an invalid parameter', :friend_id
      end

      context 'when user does not exists' do
        let!(:params) do
          build(
            :create_payment_params,
            user_id: User.last.id + 1,
            friend_id: friend.id
          )
        end

        let(:expected_message) do
          [
            I18n.t(
              :not_found,
              scope: %i[
                activemodel
                errors
                models
                validators/create_payment_params
                attributes
                user_id
              ]
            )
          ]
        end

        it_behaves_like 'an invalid parameter', :user_id

        it 'returns custom message' do
          subject.validate

          expect(subject.errors.messages_for(:user_id)).to match(expected_message)
        end
      end

      context 'when friend does not exists' do
        let!(:params) do
          build(
            :create_payment_params,
            user_id: user.id,
            friend_id: User.last.id + 1
          )
        end

        let(:expected_message) do
          [
            I18n.t(
              :not_found,
              scope: %i[
                activemodel
                errors
                models
                validators/create_payment_params
                attributes
                user_id
              ]
            )
          ]
        end

        it_behaves_like 'an invalid parameter', :friend_id

        it 'returns custom message' do
          subject.validate

          expect(subject.errors.messages_for(:friend_id)).to match(expected_message)
        end
      end
    end
  end
end
