class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def feed; end

  def balance; end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
