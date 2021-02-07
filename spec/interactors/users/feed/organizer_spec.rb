# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Feed::Organizer do
  let!(:friendship) { create(:friendship) }
  subject(:context) { described_class.call(id: friendship.user.id) }

  context 'when is a valid user' do
    let!(:payments) do
      create_list(:payment, 5, sender: friendship.user, receiver: friendship.friend)
    end

    let(:expected_payments) do
      PaymentsQuery.new.second_level_friends_payments(
        user_id: friendship.user
      ).page(1).order(
        Users::Feed::BuildResponse::DATA_JSON_ORDER
      ).as_json(
        Users::Feed::BuildResponse::DATA_JSON_FORMAT
      )
    end

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'provides response status' do
      expect(context.status).to match(:ok)
    end

    it 'provides response data' do
      expect(context.data).to include(:data)

      expect(context.data[:data]).to match(expected_payments)
    end

    it 'provides response metadata' do
      expect(context.data).to include(:metadata)

      expect(context.data[:metadata]).to include(
        page: 1,
        per_page: 10,
        total_pages: 1
      )
    end
  end

  context 'when user_id is invalid' do
    let!(:friendship) { build(:friendship) }

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
    let(:expected_errors) { ["User #{friendship.user} has no payment account associated"] }

    before do
      friendship.user.payment_account.destroy!
      friendship.user.reload
    end

    it 'fails' do
      expect(context).to be_a_failure
    end

    it 'provides expected errors' do
      expect(context.errors).to match(expected_errors)
    end
  end
end
