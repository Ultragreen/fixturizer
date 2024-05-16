module Fixturizer
    module Serializers
        class Yaml < Template
            
            
            def apply


                result = @data.to_yaml

                if @options[:to_file].is_a?(String) then 
                    write_file(@options[:to_file],result)
                else
                    return result
                end
                
                
            end
        end
    end
end
