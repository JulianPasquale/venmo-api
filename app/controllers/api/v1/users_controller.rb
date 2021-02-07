module Api
  module V1
    class UsersController < ApplicationController
      def feed; end

      def balance
        result = Users::Balance::Organizer.call(user_params)

        if result.success?
          render json: result.data, status: result.status
        else
          render_error_json(result)
        end
      end

      private

      def user_params
        params.permit(:id)
      end
    end
  end
end
