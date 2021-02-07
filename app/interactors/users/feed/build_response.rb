# frozen_string_literal: true

module Users
  module Feed
    class BuildResponse
      include Interactor

      def call
        context.status = :ok

        context.data = data
      end

      private

      def data
        PaymentsQuery.new.second_level_friends_payments(user_id: context.user)
      end
    end
  end
end
