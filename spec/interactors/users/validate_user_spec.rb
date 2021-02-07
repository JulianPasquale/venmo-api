# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::ValidateUser do
  let!(:user) { create(:user) }
  subject(:context) { described_class.call(id: user.id) }

  context 'when is a valid user' do
    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'provides user' do
      expect(context.user).to match(user)
    end

    it 'provides account' do
      expect(context.account).to match(user.payment_account)
    end
  end

  context 'when user_id is invalid' do
    let!(:user) { build(:user) }

    let(:expected_errors) { ['User not found'] }

    it 'fails' do
      expect(context).to be_a_failure
    end

    it 'provides expected errors' do
      expect(context.errors).to match(expected_errors)
      expect(context.error_status).to match(:not_found)
    end
  end

  context 'when user has no payment account' do
    let(:expected_errors) { ["User #{user} has no payment account associated"] }

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
