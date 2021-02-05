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
class Friendship < ApplicationRecord
  belongs_to :user, optional: false
  belongs_to :friend, class_name: 'User', optional: false

  validates :user_id, uniqueness: { scope: :friend_id, message: 'They are already friends' }
  validate :inverse_friendship

  private

  # This method can be moved to a custom validator.
  def inverse_friendship
    return if new_user_or_friend?

    # All user friends
    user_friends = FriendshipsQuery.new.both_ways(user_id: user.id)

    # User friendship with friend
    friendship = FriendshipsQuery.new(relation: user_friends).both_ways(user_id: friend.id)

    return unless friendship.present?

    errors.add(:user_id, 'They are already friends')
  end

  def new_user_or_friend?
    !user&.persisted? || !friend&.persisted?
  end
end
