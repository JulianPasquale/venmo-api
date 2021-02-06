# frozen_string_literal: true

module Payments
  module Create
    class TransferFunds
      include Interactor

      def call
        ActiveRecord::Base.transaction do
          create_payment!

          deduct_balance!

          add_to_balance!
        end
      rescue NoPaymentAccount => e
        context.fail!(errors: [e.message])
      rescue InsufficientFunds
        context.fail!(errors: ['Your funds are insufficient'])
      rescue ActiveRecord::RecordInvalid => e
        context.fail!(errors: e.record.errors.full_messages)
      end

      private

      def create_payment!
        Payment.create!(
          sender: context.sender,
          receiver: context.receiver,
          amount: context.amount,
          description: context.description
        )
      end

      def deduct_balance!
        AccountManager.deduct_balance!(
          user: context.sender,
          amount: context.amount
        )
      end

      def add_to_balance!
        AccountManager.add_to_balance!(
          user: context.receiver,
          amount: context.amount
        )
      end
    end
  end
end
