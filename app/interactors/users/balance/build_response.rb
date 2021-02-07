# frozen_string_literal: true

module Users
  module Balance
    class BuildResponse
      include Interactor

      def call
        context.status = :ok

        context.data = data
      end

      private

      def data
        {
          user: {
            email: context.user.email,
            first_name: context.user.first_name,
            last_name: context.user.last_name,
            account: { balance: context.account.balance.to_f }
          }
        }
      end
    end
  end
end
