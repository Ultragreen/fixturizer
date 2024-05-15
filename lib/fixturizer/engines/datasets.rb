
module Fixturizer
    module Engines
        class Dataset

            def initialize(dataset: )
            @dataset = dataset
            @configuration = Fixturizer::Configuration::new filename: './config/rules.yml'
            end
        end
    end
end
