module Api
  module V1
    class UsersController < ApplicationController
      def feed
        result = Users::Feed::Organizer.call(feed_params)

        if result.success?
          render json: result.data, status: result.status
        else
          render_error_json(result)
        end
      end

      def balance
        result = Users::Balance::Organizer.call(balance_params)

        if result.success?
          render json: result.data, status: result.status
        else
          render_error_json(result)
        end
      end

      private

      def balance_params
        params.permit(:id)
      end

      def feed_params
        params.permit(:id, :page)
      end
    end
  end
end
