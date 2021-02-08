# frozen_string_literal: true

module Users
  module Balance
    class Organizer
      include Interactor::Organizer

      organize ValidateUser, BuildResponse
    end
  end
end
