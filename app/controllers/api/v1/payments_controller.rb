module Api
  module V1
    class PaymentsController < ApplicationController
      def create
        result = Payments::Create::Organizer.call(create_params)

        if result.success?
          render :ok
        else
          render_error_json(result)
        end
      end

      private

      def create_params
        params.permit(:user_id, :friend_id, :amount, :description)
      end
    end
  end
end
