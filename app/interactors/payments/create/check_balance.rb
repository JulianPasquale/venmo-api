# frozen_string_literal: true

module Payments
  module Create
    class CheckBalance
      include Interactor

      def call
        context.sender = sender
        context.receiver = receiver

        # We should charge account
        transfer_from_bank unless context.sender.balance >= context.amount
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

      def transfer_from_bank
        transfer_service = MoneyTransferService.new(
          Object.new, sender
        )

        negative_balance_error unless transfer_service.transfer(context.amount - sender.balance)
      end

      def negative_balance_error
        context.fail!(errors: ['Your funds are insufficient and transfer from bank failed'])
      end
    end
  end
end
