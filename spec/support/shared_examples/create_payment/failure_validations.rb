# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_context 'a failed validation' do
  let(:validator) { Validators::CreatePaymentParams.new(params) }

  it 'fails' do
    expect(context).to be_a_failure
  end

  it 'provides errors messages from validator' do
    validator.validate
    expect(context.errors).to match(validator.errors.full_messages)
  end
end
