# frozen_string_literal: true

module Fixturizer
  module Rspec
    module Helpers
      class Records
        include Singleton

        def apply(value:, rule:)
          Fixturizer::Services.get.engine(name: :record, parameters: { value:, rule: }).apply
        end
      end
    end
  end
end

def record
  Fixturizer::Rspec::Helpers::Records.instance
end
