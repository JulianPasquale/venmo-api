# frozen_string_literal: true

class FriendshipsQuery < ::BaseQuery
  def both_ways(user_id:)
    relation.where(user_id: user_id).or(relation.where(friend_id: user_id))
  end

  private

  def model_name
    Friendship
  end
end
