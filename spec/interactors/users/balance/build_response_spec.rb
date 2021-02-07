# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Balance::BuildResponse do
  let!(:user) { create(:user) }
  let!(:params) { build(:build_balance_response_params, user: user) }

  subject(:context) { described_class.call(params) }

  it 'succeeds' do
    expect(context).to be_a_success
  end

  it 'provides response status' do
    expect(context.status).to match(:ok)
  end

  it 'provides response data' do
    expect(context.data).to include(:user)

    expect(context.data[:user]).to include(
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      account: {
        balance: user.balance
      }
    )
  end
end
