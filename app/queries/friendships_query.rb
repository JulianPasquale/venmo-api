# frozen_string_literal: true

class FriendshipsQuery < BaseQuery
  def both_ways(user_id:, relation: @relation)
    relation.where(user_id: user_id).or(relation.where(friend_id: user_id))
  end

  def friendship_between(user_id:, friend_id:)
    # All user friends
    user_friendships = both_ways(user_id: user_id)

    # User friendship with friend
    both_ways(user_id: friend_id, relation: user_friendships)
  end

  def friends?(user_id:, friend_id:)
    friendship_between(user_id: user_id, friend_id: friend_id).present?
  end

  private

  def model_name
    Friendship
  end
end
