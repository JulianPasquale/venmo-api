# frozen_string_literal: true

module Users
  class ValidateUser
    include Interactor

    def call
      return not_found_user_error if user.blank?

      return no_payment_account_error if account.blank?

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
      context.fail!(
        errors: [I18n.t(:user_not_found, scope: %i[interactors errors])],
        error_status: :not_found
      )
    end

    def no_payment_account_error
      context.fail!(
        errors: [
          I18n.t(
            :no_payment_account,
            scope: %i[interactors errors],
            user: user
          )
        ]
      )
    end
  end
end
