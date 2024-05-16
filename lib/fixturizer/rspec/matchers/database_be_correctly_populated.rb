# frozen_string_literal: true

RSpec::Matchers.define :be_correctly_populated do
  match do |actual|
    actual.populate == true
  end
  description do
    'be effectively populated.'
  end
  failure_message do |_actual|
    "expected database populate response to be true \ngot : false "
  end
  failure_message_when_negated do |_actual|
    "expected database populate response to be false \ngot : true "
  end
end
