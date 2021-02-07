# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Feed::BuildResponse do
  let!(:user) { create(:user) }

  let!(:friendships) { create_list(:friendship, 2, user: user) }

  let!(:params) { build(:build_feed_response_params, user: user) }

  subject(:context) { described_class.call(params) }

  let(:expected_payments) do
    PaymentsQuery.new.second_level_friends_payments(
      user_id: user
    ).page(params[:page]).order(
      Users::Feed::BuildResponse::DATA_JSON_ORDER
    ).as_json(
      Users::Feed::BuildResponse::DATA_JSON_FORMAT
    )
  end

  context 'when provides page param' do
    let!(:payments) do
      create_list(:payment, 10, sender: user, receiver: friendships.first.friend)
    end

    let!(:params) { build(:build_feed_response_params, user: user) }

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'provides response status' do
      expect(context.status).to match(:ok)
    end

    it 'provides response data' do
      expect(context.data[:data].size).to eq(10)
      expect(context.data[:data]).to match(expected_payments)
    end

    it 'provides response metadata' do
      expect(context.data[:metadata]).to include(
        page: params[:page],
        per_page: 10,
        total_pages: 1
      )
    end

    context 'when payments are paginated' do
      let!(:payments) do
        create_list(:payment, 30, sender: user, receiver: friendships.first.friend)
      end

      it 'provides response metadata' do
        expect(context.data[:metadata]).to include(
          page: params[:page],
          per_page: 10,
          total_pages: 3
        )
      end
    end

    context 'when requests second page' do
      let!(:payments) do
        create_list(:payment, 30, sender: user, receiver: friendships.first.friend)
      end

      let!(:params) { build(:build_feed_response_params, user: user, page: 2) }

      it 'provides response metadata' do
        expect(context.data[:metadata]).to include(
          page: params[:page],
          per_page: 10,
          total_pages: 3
        )
      end
    end
  end

  context 'when using default page number' do
    let!(:payments) do
      create_list(:payment, 30, sender: user, receiver: friendships.first.friend)
    end

    let!(:params) { build(:build_feed_response_params, user: user, page: nil) }

    it 'provides response metadata' do
      expect(context.data[:metadata]).to include(
        page: 1,
        per_page: 10,
        total_pages: 3
      )
    end
  end
end
