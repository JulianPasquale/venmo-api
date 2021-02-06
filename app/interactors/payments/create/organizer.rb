# frozen_string_literal: true

module Payments
  module Create
    class Organizer
      include Interactor::Organizer

      organize ValidateParams, CheckBalance, TransferMoney
    end
  end
end
