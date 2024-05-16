 module Fixturizer
    module Rspec 
        module Helpers
            class Records

                include Singleton

                def apply(value: , rule:)
                    return Fixturizer::Services.get.engine(name: :record, parameters: {value: value, rule: rule}).apply
                end
            end
        end
    end
end

def record
    return Fixturizer::Rspec::Helpers::Records.instance
end
