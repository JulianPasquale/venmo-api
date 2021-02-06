# frozen_string_literal: true

module Payments
  module Create
    class ValidateParams
      include Interactor

      def call
        validator = Validators::CreatePaymentParams.new(context.to_h)

        return respond_with_error(validator) unless validator.valid?

        return no_friendship_error unless friendship.present?

        context.friendship = friendship
      end

      private

      def respond_with_error(validator)
        if validator.errors[:user_id].present? || validator.errors[:friend_id].present?
          context.error_status = :not_found
        end

        context.fail!(errors: validator.errors.full_messages)
      end

      def friendship
        @friendship ||= FriendshipsQuery.new.friendship_between(
          context.to_h.slice(:user_id, :friend_id)
        ).eager_load(user: :payment_account, friend: :payment_account).first
      end

      def no_friendship_error
        context.fail!(errors: ['Users are not friends'])
      end
    end
  end
end
