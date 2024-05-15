module Fixturizer
    module Helpers
        class Database

            include Singleton

            def drop
                begin
                    Fixturizer::Engines::Models::new(filename: './config/rules.yml').drop_database
                rescue StandardError
                    return false
                end
            end


            def populate
                begin
                    my_fixturer = Fixturizer::Engines::Models::new(filename: './config/rules.yml')
                    my_fixturer.generate_data
                    my_fixturer.inject_data
                    return true
                rescue StandardError
                    return false
                end
            end
        end
    end
end

def database
    return Fixturizer::Helpers::Database.instance
end


