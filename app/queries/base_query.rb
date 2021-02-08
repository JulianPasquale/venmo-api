# frozen_string_literal: true

class BaseQuery
  attr_reader :relation

  def initialize(relation: model_name.all)
    @relation = relation
  end

  private

  def model_name
    raise 'Implement this in subclasses'
  end
end
