# == Schema Information
#
# Table name: payments
#
#  id          :bigint           not null, primary key
#  amount      :decimal(10, 2)   default(0.0), not null
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :bigint           not null
#  sender_id   :bigint           not null
#
# Indexes
#
#  index_payments_on_receiver_id  (receiver_id)
#  index_payments_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
class Payment < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :amount, presence: true, numericality: { greater_than: 0, less_than: 1000 }

  validate :self_payment
  validate :users_friendship

  def title
    "#{sender} paid #{receiver} on #{created_at} - #{description}"
  end

  private

  def self_payment
    return unless sender_id == receiver_id

    errors.add(:sender_id, :self_payment)
  end

  def users_friendship
    return if sender.blank? || receiver.blank?
    return if sender.friends.include?(receiver)

    errors.add(:sender_id, :no_friendship)
  end
end
