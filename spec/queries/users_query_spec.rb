# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersQuery do
  let!(:user) { create(:user) }
  subject { described_class.new }

  describe '#friends' do
    context 'when users has friends' do
      let(:friendship) { create(:friendship, user: user) }

      it 'includes friendship in response' do
        expect(subject.friends(user_id: user)).to match(
          [friendship.friend]
        )
      end
    end

    context 'when users are not friends' do
      it 'returns an empty response' do
        expect(subject.friends(user_id: user)).to match([])
      end
    end

    context 'when provides relation on initialize' do
      let(:friendships) { create_list(:friendship, 3, user: user) }

      subject do
        described_class.new(
          relation: User.where(id: [friendships.first.friend_id])
        )
      end

      it 'returns friends included in relation' do
        expect(subject.friends(user_id: user.id)).to match([friendships.first.friend])
      end
    end

    context 'when using scope true' do
      it 'do not include inner join clause on sql query' do
        expect(subject.friends(user_id: user, scope: true).to_sql).to_not include('INNER JOIN friendships')
      end

      it 'include or condition' do
        expect(subject.friends(user_id: user, scope: true).to_sql).to include('OR users.id = friendships.user_id')
      end
    end

    context 'when using scope false' do
      it 'includes inner join clause on sql query' do
        expect(subject.friends(user_id: user, scope: false).to_sql).to include('INNER JOIN friendships')
      end

      it 'includes on conditions' do
        expect(subject.friends(user_id: user, scope: false).to_sql).to include('ON users.id = friendships.friend_id')
        expect(subject.friends(user_id: user, scope: false).to_sql).to include('OR users.id = friendships.user_id')
      end
    end
  end

  describe '#model_name' do
    it 'returns user class' do
      expect(subject.send(:model_name)).to match(User)
    end
  end

  describe '#friends_up_to_second_level' do
    let!(:user) { create(:user) }
    let!(:first_level_friendships) { create_list(:friendship, 2, user: user) }
    let!(:second_level_friendships1) { create_list(:friendship, 2, user: first_level_friendships.first.friend) }
    let!(:second_level_friendships2) { create(:friendship, user: first_level_friendships.second.friend) }

    let(:expected_result) do
      first_level_friends = user.friends
      second_level_friends = first_level_friends.map(&:friends).flatten

      ([user] + first_level_friends + second_level_friends).sort_by(&:id)
    end

    it 'includes user direct friends' do
      expect(subject.friends_up_to_second_level(user_id: user)).to include(*user.friends)
    end

    it "includes the friends of the user's friends (second level)" do
      expect(subject.friends_up_to_second_level(user_id: user)).to(
        include(*first_level_friendships.first.friend.friends)
      )
      expect(subject.friends_up_to_second_level(user_id: user)).to(
        include(*first_level_friendships.second.friend.friends)
      )
    end

    it 'matchs with expected friends list' do
      expect(subject.friends_up_to_second_level(user_id: user).order(:id)).to match(expected_result)
    end
  end
end
