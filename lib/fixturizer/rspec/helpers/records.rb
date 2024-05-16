 module Fixturizer
    module Rspec 
        module Helpers
            class Records

                include Singleton

                def apply(value: , rule:)
                    engine = Fixturizer::Engines::Record::new value: value, rule: rule
                    return engine.apply
                end
            end
        end
    end
end

def record
    return Fixturizer::Rspec::Helpers::Records.instance
end
