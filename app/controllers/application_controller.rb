class ApplicationController < ActionController::API
  private

  def render_error_json(result)
    render json: {
      status: :error,
      errors: result.errors
    }, status: result.error_status || :unprocessable_entity
  end
end
