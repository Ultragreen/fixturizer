# frozen_string_literal: true

RSpec::Matchers.define :be_correctly_dropped do
    match do |actual|
      actual.drop == true
    end
    description do
      'be effectively dropped.'
    end
    failure_message do |actual|
      "expected database drop response to be true \ngot : false "
    end
    failure_message_when_negated do |actual|
      "expected database drop response to be false \ngot : true "
    end
  end