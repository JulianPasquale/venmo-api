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

  has_one :payment_account, dependent: :destroy

  has_many :received_payments, dependent: :destroy, class_name: 'Payment', foreign_key: 'receiver_id'
  has_many :sended_payments, dependent: :destroy, class_name: 'Payment', foreign_key: 'sender_id'

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :first_name, :last_name, presence: true

  delegate :balance, to: :payment_account

  # This callback could be omitted using a service
  # to create users and payment accounts in a transaction.
  after_create :create_payment_account

  private

  def create_payment_account
    PaymentAccount.create!(user: self)
  end
end
