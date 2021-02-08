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
          if context.friendship.user.id == context.user_id.to_i
            context.friendship.user
          else
            context.friendship.friend
          end
        end
      end

      def receiver
        @receiver ||= begin
          if context.friendship.user.id == context.friend_id.to_i
            context.friendship.user
          else
            context.friendship.friend
          end
        end
      end

      def transfer_from_bank
        transfer_service = MoneyTransferService.new(
          Object.new, sender
        )

        if transfer_service.transfer(context.amount - sender.balance)
          context.sender.reload
        else
          negative_balance_error
        end
      end

      def negative_balance_error
        context.fail!(
          errors: [
            I18n.t(
              :insufficient_funds_and_transfer_error,
              scope: %i[interactors errors]
            )
          ]
        )
      end
    end
  end
end
