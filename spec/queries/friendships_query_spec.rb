# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendshipsQuery do
  let(:relation) { Friendship.all }
  subject { described_class.new(relation: relation) }

  describe '#both_ways' do
    let(:user) { create(:user) }
    let(:friendship1) { create(:friendship, user: user) }
    let(:friendship2) { create(:friendship, friend: user) }

    it 'returns all user friendships' do
      expect(subject.both_ways(user_id: user.id)).to match([friendship1, friendship2])
    end

    it 'returns scoped user friendships' do
      expect(subject.both_ways(user_id: user.id, relation: relation.limit(1))).to(
        match([friendship1])
      )
    end
  end

  describe '#friendship_between' do
    let(:friendship) { create(:friendship) }

    it 'returns expected relation' do
      expect(subject.friendship_between(user_id: friendship.user, friend_id: friendship.friend)).to(
        match([friendship])
      )
    end

    it 'returns an empty result' do
      expect(subject.friendship_between(user_id: friendship.user, friend_id: nil)).to(
        match([])
      )
    end
  end

  describe '#friends?' do
    let(:friendship) { create(:friendship) }

    context 'when users are friends' do

      it 'returns true' do
        expect(subject.friends?(user_id: friendship.user, friend_id: friendship.friend)).to be true
      end
    end

    context 'when users are not friends' do
      it 'returns false' do
        expect(subject.friends?(user_id: friendship.user, friend_id: nil)).to be false
      end
    end
  end
end
