# frozen_string_literal: true

module Validators
  class CreatePaymentParams
    include ActiveModel::Validations
    include ActiveModel::Model

    attr_accessor :user_id, :friend_id, :amount, :description

    validates_presence_of :user_id, :friend_id, :amount

    validates_numericality_of :amount, greater_than: 0, less_than: 1000

    validate :valid_users?

    private

    def valid_users?
      users_ids = User.where(id: [user_id, friend_id]).pluck(:id)
      return if users_ids.count == 2

      if users_ids.include?(user_id.to_i)
        errors.add(:friend_id, 'does not exists')
      else
        errors.add(:user_id, 'does not exists')
      end
    end
  end
end
