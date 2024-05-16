# frozen_string_literal: true

module Fixturizer
  module Rspec
    module Helpers
      class Datasets
        include Singleton

        def generate(dataset:)
          Fixturizer::Services.get.engine(name: :dataset, parameters: { dataset: }).generate
        end
      end
    end
  end
end

def datasets
  Fixturizer::Rspec::Helpers::Datasets.instance
end
