# frozen_string_literal: true

class UsersQuery < BaseQuery
  def friends(user_id:, scope: false, relation: @relation)
    query = relation.joins(friends_query(scope: scope)).where.not(id: user_id)

    query.where(friendships: { user_id: user_id }).or(
      query.where(friendships: { friend_id: user_id })
    )
  end

  # This method result also include the user with id `user_id`.
  def friends_up_to_second_level(user_id:, relation: @relation)
    first_level_friends = friends(user_id: user_id, relation: relation)
    friends(user_id: first_level_friends).unscope(where: :id).distinct
  end

  private

  def model_name
    User
  end

  def friends_query(scope: false)
    if scope
      <<~SQL
        OR users.id = friendships.user_id
      SQL
    else
      <<~SQL
        INNER JOIN friendships
          ON users.id = friendships.friend_id
          OR users.id = friendships.user_id
      SQL
    end
  end
end
