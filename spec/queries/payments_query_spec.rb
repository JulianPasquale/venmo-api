# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentsQuery do
  let(:relation) { Payment.all }
  subject { described_class.new }

  describe '#sended_payments' do
    let(:user) { create(:user) }
    let(:payments) { create_list(:payment, 2, sender: user) }

    it 'returns payments sended by user' do
      expect(subject.sended_payments(user_id: user)).to match(payments)
    end
  end

  describe '#received_payments' do
    let(:user) { create(:user) }
    let(:payments) { create_list(:payment, 2, receiver: user) }

    it 'returns payments received by user' do
      expect(subject.received_payments(user_id: user)).to match(payments)
    end
  end

  describe '#all_payments' do
    let(:user) { create(:user) }
    let(:sended_payments) { create_list(:payment, 2, receiver: user) }
    let(:received_payments) { create_list(:payment, 2, receiver: user) }

    it 'returns payments received by user' do
      expect(subject.all_payments(user_id: user)).to(
        match(sended_payments + received_payments)
      )
    end
  end

  describe '#second_level_friends_payments' do
    let!(:user) { create(:user) }

    let!(:first_level_friendships) { create_list(:friendship, 2, user: user) }
    let!(:second_level_friendships1) do
      create_list(:friendship, 2, user: first_level_friendships.first.friend)
    end
    let!(:second_level_friendships2) do
      create(:friendship, user: first_level_friendships.second.friend)
    end

    let!(:third_level_user) { create(:user) }
    let!(:third_level_friendship) do
      create(:friendship, user: third_level_user)
    end

    let!(:payments_to_include) do
      create_list(:payment, 2, receiver: user) +
        create_list(:payment, 2, sender: user) +
        create_list(:payment, 2, sender: first_level_friendships.first.friend)
    end

    let!(:payments_to_exclude) do
      create_list(
        :payment,
        2,
        sender: third_level_friendship.user,
        receiver: third_level_friendship.friend
      )
    end

    it 'returns expected payments' do
      expect(subject.second_level_friends_payments(user_id: user).pluck(:id).sort).to(
        match(payments_to_include.map(&:id).sort)
      )

      expect(subject.second_level_friends_payments(user_id: user)).to_not(
        include(*payments_to_exclude)
      )
    end
  end
end
