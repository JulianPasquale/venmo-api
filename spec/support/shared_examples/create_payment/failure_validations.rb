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

RSpec.shared_context 'an invalid parameter' do |field_name|
  it 'is not valid' do
    expect(subject).to_not be_valid
  end

  it 'includes field with error' do
    subject.validate

    expect(subject.errors).to_not be_empty
    expect(subject.errors.attribute_names).to match([field_name.to_sym])
  end
end
