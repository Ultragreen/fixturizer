module Fixturizer
    module Rspec 
        module Helpers
            class Serializer

                include Singleton

                def to(format: , data:, raw: false, to_file: nil)
                    options = {}; options[:raw] = raw; options[:to_file] = to_file;
                    return Fixturizer::Services.get.serializer(name: format, parameters: {data: data, options: options}).apply
                end
            end
        end
    end
end

def serialize
    return Fixturizer::Rspec::Helpers::Serializer.instance
end