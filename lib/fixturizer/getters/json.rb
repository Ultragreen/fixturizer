# frozen_string_literal: true

module Fixturizer
    module Getters
      class Json < Template
        def retrieve
          result = nil
          data = read_file(@filename)
          result = JSON.parse(data, symbolize_names: @options[:symbolize])
          return result
  
        end
      end
    end
  end
  