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
#  index_friendships_on_friend_id              (friend_id)
#  index_friendships_on_user_id                (user_id)
#  index_friendships_on_user_id_and_friend_id  (user_id,friend_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (friend_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
class Friendship < ApplicationRecord
  belongs_to :user, optional: false
  belongs_to :friend, class_name: 'User', optional: false

  validates :user_id, uniqueness: { scope: :friend_id, message: :already_friends }
  validate :inverse_friendship

  private

  # This method can be moved to a custom validator.
  def inverse_friendship
    return if new_user_or_friend?

    return unless FriendshipsQuery.new.friends?(user_id: user.id, friend_id: friend.id)

    errors.add(:user_id, :already_friends)
  end

  def new_user_or_friend?
    !user&.persisted? || !friend&.persisted?
  end
end
