
module Fixturizer
    module Engines
        class Dataset

            attr_reader :name, :dataset

            def initialize(dataset: )
                @name = dataset
                @configuration = Fixturizer::Configuration::new filename: './config/rules.yml'
                @dataset = (dataset.is_a?(Symbol))? @configuration.datasets[@name] : dataset
                @rules = @configuration.rules
                @effectives_rules  = @dataset[:rules]
            end


            def generate
                data = @dataset[:definition]
                result = substitute_values(data)
                return result 
            end

            private
            def map_value(key, value)
                return value if @effectives_rules.nil? 
                if @effectives_rules.key? key then
                    value = eval("lambda { #{@rules[@effectives_rules[key]][:proc]} } ").call unless @rules[@effectives_rules[key]].dig(:preserve) == true and !value.nil?
                end
                return value
            end

            def substitute_values(obj)
                return obj.map { |v| substitute_values(v) } if obj.is_a? Array
                return obj unless obj.is_a? Hash
                obj.each_with_object({}) do |(key, value), result|
                  if value.is_a? Hash
                    result[key] = substitute_values(value)
                  elsif value.is_a?(Array)
#                    result[key] = value.map { |v| v.is_a?(Hash)? substitute_values(v) : v }
                    result[key] = value.map { |v| substitute_values(v) }
                  else
                    result[key] = map_value(key, value)
                  end
                end
              end
            
              

        end
    end
end
