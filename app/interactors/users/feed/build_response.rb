# frozen_string_literal: true

module Users
  module Feed
    class BuildResponse
      include Interactor

      def call
        context.status = :ok

        context.data = response_data
      end

      private

      def response_data
        {
          data: data.as_json(methods: [:title], only: %i[amount description]),
          metadata: {
            page: page_number,
            per_page: data.limit_value,
            total_pages: data.total_pages
          }
        }
      end

      def data
        @data ||= PaymentsQuery.new.second_level_friends_payments(
          user_id: context.user
        ).page(page_number)
      end

      def page_number
        (context.page || 1).to_i
      end
    end
  end
end
