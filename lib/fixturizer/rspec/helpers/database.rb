# frozen_string_literal: true

module Fixturizer
  module Rspec
    module Helpers
      class Database
        include Singleton

        def drop
          Fixturizer::Services.get.engine(name: :models).drop_database
        rescue StandardError
          false
        end

        def populate
          Fixturizer::Services.get.engine(name: :models).populate
        rescue StandardError
          false
        end
      end
    end
  end
end

def database
  Fixturizer::Rspec::Helpers::Database.instance
end
