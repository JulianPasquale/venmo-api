# frozen_string_literal: true

module Users
  module Balance
    class ValidateUser
      include Interactor

      def call
        return not_found_user_error unless user.present?

        return no_payment_account_error unless account.present?

        context.user = user
        context.account = account
      end

      private

      def user
        @user ||= User.where(id: context.id).eager_load(:payment_account).first
      end

      def account
        @account ||= user.payment_account
      end

      def not_found_user_error
        context.fail!(errors: ['User not found'], error_status: :not_found)
      end

      def no_payment_account_error
        context.fail!(errors: ["User #{user} has no payment account associated"])
      end
    end
  end
end