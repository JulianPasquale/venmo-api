# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_many :friendships,
           ->(user) { FriendshipsQuery.new.both_ways(user_id: user.id) },
           inverse_of: :user,
           dependent: :destroy

  has_many :friends,
           ->(user) { UsersQuery.new.friends(user_id: user.id, scope: true) },
           through: :friendships

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, :last_name, presence: true
end
