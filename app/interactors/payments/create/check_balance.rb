# frozen_string_literal: true

module Payments
  module Create
    class CheckBalance
      include Interactor

      def call
        context.sender = sender
        context.receiver = receiver

        # We should charge account instead
        # negative_balance_error unless context.sender.balance >= context.amount
      end

      private

      def sender
        @sender ||= begin
          return context.friendship.user if context.friendship.user.id == context.user_id.to_i

          context.friendship.friend
        end
      end

      def receiver
        @receiver ||= begin
          return context.friendship.user if context.friendship.user.id == context.friend_id.to_i

          context.friendship.friend
        end
      end

      def negative_balance_error
        context.fail!(errors: ['You have not enough money!'])
      end
    end
  end
end
