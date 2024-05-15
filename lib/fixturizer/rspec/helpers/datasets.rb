 module Fixturizer
    module Helpers
        class Datasets

            include Singleton

            def generate(dataset: )
                p dataset
            end
        end
    end
end

def datasets
    return Fixturizer::Helpers::Datasets.instance
end
