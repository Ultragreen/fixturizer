module Fixturizer
    module Serializers
        class Json < Template
            
            
            def apply
                result = ""
                if @options[:raw] then 
                    result =  @data.to_json
                else
                    result = JSON.pretty_generate(@data).concat("\n")
                end
                if @options[:to_file].is_a?(String) then 
                    write_file(@options[:to_file],result)
                else
                    return result
                end
                
                
            end
        end
    end
end
