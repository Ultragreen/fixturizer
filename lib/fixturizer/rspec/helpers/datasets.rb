 module Fixturizer
    module Helpers
        class Datasets

            include Singleton

            def generate(dataset: )
                engine = Fixturizer::Engines::Dataset::new dataset: dataset
                p engine.generate
            end
        end
    end
end

def datasets
    return Fixturizer::Helpers::Datasets.instance
end
