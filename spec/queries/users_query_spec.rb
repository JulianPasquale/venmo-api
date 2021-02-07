# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersQuery do
  let(:relation) { User.all }
  let!(:user) { create(:user) }
  subject { described_class.new(relation: relation) }

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
end
