# frozen_string_literal: true

class PaymentsQuery < BaseQuery
  def sended_payments(user_id:, relation: @relation)
    relation.where(sender_id: user_id)
  end

  def received_payments(user_id:, relation: @relation)
    relation.where(receiver_id: user_id)
  end

  def all_payments(user_id:, relation: @relation)
    sended_payments(user_id: user_id, relation: relation).or(
      received_payments(user_id: user_id, relation: relation)
    )
  end

  def second_level_friends_payments(user_id:, relation: @relation)
    all_payments(
      user_id: UsersQuery.new.friends_up_to_second_level(user_id: user_id),
      relation: relation
    ).distinct
  end

  private

  def model_name
    Payment
  end
end
