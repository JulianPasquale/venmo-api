# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BaseQuery do
  let(:relation) { Object.new }
  subject { described_class.new(relation: relation) }

  describe '.new' do
    it 'sets relation attribute' do
      expect(subject.relation).to match(relation)
    end
  end

  describe '#model_name' do
    it 'raises an exception' do
      expect { subject.send(:model_name) }.to raise_error(
        'Implement this in subclasses'
      )
    end
  end
end
