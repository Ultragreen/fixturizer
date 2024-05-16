module Fixturizer
    module Engines
        class Dataset

            attr_reader :name, :dataset

            def initialize(dataset: )
                @name = dataset
                @configuration = Fixturizer::Configuration::new filename: './config/rules.yml'
                @dataset = (dataset.is_a?(Symbol))? @configuration.datasets[@name] : dataset
                @effectives_rules  = @dataset[:rules]
            end

            def generate
                data = @dataset[:definition]
                result = substitute_values(data)
                return result 
            end

            private
            def apply_rule(key, value, rule)
                if @effectives_rules.key? key then
                   value = Fixturizer::Engines::Record::new(value: value, rule: rule).apply
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
                    result[key] = value.map { |v| substitute_values(v) }
                  else
                    result[key] =  (@effectives_rules.nil?)? value : apply_rule(key, value, @effectives_rules[key])
                  end
                end
              end
            

        end
    end
end
