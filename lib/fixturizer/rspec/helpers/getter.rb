# frozen_string_literal: true

module Fixturizer
  module Rspec
    module Helpers
      class Getter
        include Singleton

        def from(format:, symbolize: true, file: )
          options = {symbolize: symbolize}
          Fixturizer::Services.get.getter(name: format,
                                              parameters: {
                                                filename: file, options: options
                                              }).retrieve
        end
      end
    end
  end
end

def get_content
  Fixturizer::Rspec::Helpers::Getter.instance
end

