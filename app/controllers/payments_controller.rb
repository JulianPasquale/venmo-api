class PaymentsController < ApplicationController
  before_action :set_user, only: [:create]

  def create; end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
