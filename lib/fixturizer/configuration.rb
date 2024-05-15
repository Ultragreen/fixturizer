module Fixturizer
    class Configuration

        attr_reader :rules, :models, :datasets, :models_order, :models_type
    
        def initialize(filename:)
          @content = read_file(filename: filename)
          @rules = @content[:fixtures].dig(:rules)
          @models_type = @content[:fixtures].dig(:models,:type)
          @models = @content[:fixtures].dig(:models,:definitions)
          @models_order = @content[:fixtures].dig(:models,:order)
          @datasets = @content[:fixtures].dig(:datasets)
        end
    
    
        private
        def read_file(filename:)
          return YAML.load(File::readlines(filename).join)
        end
    
    
      end 
end