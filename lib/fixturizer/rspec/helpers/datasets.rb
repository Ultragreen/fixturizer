 module Fixturizer
    module Rspec
        module Helpers
            class Datasets
                
                include Singleton
                
                def generate(dataset: )
                    return Fixturizer::Services.get.engine(name: :dataset, parameters: {dataset: dataset}).generate
                end
            end
        end
    end
end

def datasets
    return Fixturizer::Rspec::Helpers::Datasets.instance
end
