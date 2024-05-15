module Fixturizer
    class Configuration

        attr_reader :rules, :models, :datasets
    
        def initialize(filename:)
          @content = read_file(filename: filename)
          @rules = @content[:fixtures].dig(:rules,:generation)
          @models = @content[:fixtures][:models][:definitions]
          @datasets = @content[:fixtures][:models]
        end
    
    
        private
        def read_file(filename:)
          return YAML.load(File::readlines(filename).join)
        end
    
    
      end 
end