module Fixturizer
    module Rspec
        module Helpers
            class Database
                
                include Singleton
                
                def drop
                    begin
                        Fixturizer::Services.get.engine(name: :models).drop_database
                    rescue StandardError
                        return false
                    end
                end
                
                
                def populate
                    begin
                        Fixturizer::Services.get.engine(name: :models).populate
                    rescue StandardError
                        return false
                    end
                end
            end
        end
    end
end

def database
    return Fixturizer::Rspec::Helpers::Database.instance
end


