# frozen_string_literal: true

# == Schema Information
#
# Table name: friendships
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  friend_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_friendships_on_friend_id  (friend_id)
#  index_friendships_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (friend_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(build_stubbed(:user)).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:friend).class_name('User') }
  end

  describe 'validations' do
    subject { build(:friendship) }

    it { should validate_uniqueness_of(:user_id).scoped_to(:friend_id).with_message('They are already friends') }
  end

  describe 'custom validations' do
    describe '#inverse_friendship' do
      let(:user) { create(:user) }
      let(:friend) { create(:user) }

      subject { create(:friendship, user: user, friend: friend) }

      context 'when users are friends' do
        before do
          subject
        end

        it 'does not allow repeated friendships' do
          expect { subject }.to_not(change { Friendship.count })
        end
      end

      context 'when users are not friends' do
        it 'creates users friendship' do
          expect { subject }.to(change { Friendship.count }.by(1))
          expect(Friendship.last).to have_attributes(user: user, friend: friend)
        end
      end
    end
  end
end
