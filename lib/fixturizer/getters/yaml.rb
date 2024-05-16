# frozen_string_literal: true

module Fixturizer
    module Getters
      class Yaml < Template
        def retrieve
          result = nil
          data = read_file(@filename)
          result = YAML.load(data, symbolize_names: @options[:symbolize])
          return result
  
        end
      end
    end
  end
  