# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Balance::Organizer do
  let!(:user) { create(:user) }
  subject(:context) { described_class.call(id: user.id) }

  context 'when is a valid user' do
    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'provides response status' do
      expect(context.status).to match(:ok)
    end

    it 'provides response data' do
      expect(context.data).to include(:user)

      expect(context.data[:user]).to include(
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        account: {
          balance: user.balance
        }
      )
    end
  end

  context 'when user_id is invalid' do
    let!(:user) { build(:user) }

    let(:expected_errors) { [I18n.t(:user_not_found, scope: %i[interactors errors])] }

    it 'fails' do
      expect(context).to be_a_failure
    end

    it 'provides expected errors' do
      expect(context.errors).to match(expected_errors)
      expect(context.error_status).to match(:not_found)
    end
  end

  context 'when user has no payment account' do
    let(:expected_errors) do
      [
        I18n.t(
          :no_payment_account,
          scope: %i[interactors errors],
          user: user
        )
      ]
    end

    before do
      user.payment_account.destroy!
      user.reload
    end

    it 'fails' do
      expect(context).to be_a_failure
    end

    it 'provides expected errors' do
      expect(context.errors).to match(expected_errors)
    end
  end
end
