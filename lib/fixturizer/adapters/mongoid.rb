# frozen_string_literal: true

module Fixturizer
  module Adapters
    module Mongoid
      def inject_data
        list = (@orders.is_a? Array)? @order : @generated.keys
        list.each do |name|
          records = @generated[name]
          records.each do |record|
            belong = record.dig(:belong,:to)
            by = record.dig(:belong,:by)
            pattern = record.dig(:belong,:search_by)
            if link.is_a? Symbol then
              model = Object.const_get(@models[belong][:class]).find_by(**pattern).send by
              model.create!(record[:data]) unless model.where(@models[belong][:unicity] => record[:data][@models[belong][:unicity]]).exists?
            else
              model = Object.const_get(@models[name][:class])
              model.create!(record[:data]) unless model.where(@models[name][:unicity] => record[:data][@models[name][:unicity]]).exists?
            end

          end
          
        end
      end


      def drop_database
        ::Mongoid.purge!
        true
      rescue StandardError
        false
      end

      def check
        res = {}
        begin
          node = ::Mongoid.default_client.cluster.addresses.first.to_s
          dbname = ::Mongoid.default_client.database.name
          client = ::Mongo::Client.new("mongodb://#{node}/#{dbname}")
          client.database_names
          return true
        rescue ::Mongo::Auth::Unauthorized, Mongo::Error
          return false
        end
        res
      end
    end
  end
end
