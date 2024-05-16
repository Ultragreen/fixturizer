 module Fixturizer
    module Rspec
        module Helpers
            class Datasets
                
                include Singleton
                
                def generate(dataset: )
                    engine = Fixturizer::Engines::Dataset::new dataset: dataset
                    return engine.generate
                end
            end
        end
    end
end

def datasets
    return Fixturizer::Rspec::Helpers::Datasets.instance
end
