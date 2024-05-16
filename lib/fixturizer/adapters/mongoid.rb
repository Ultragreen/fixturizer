# frozen_string_literal: true

module Fixturizer
  module Adapters
    module Mongoid
      def injector(model_infos:, item:)
        model = Object.const_get(model_infos[:class])
        model.create!(item) unless model.where(model_infos[:unicity] => item[model_infos[:unicity]]).exists?
      end

      def binder(item:)
        result = {}
        item.each do |element|
          model_class = @models[element[:collection]][:class]
          model = Object.const_get(model_class)
          if element[:index].include?(:at)
            result[element[:fkey]] = model.all[element[:index][:at] - 1][element[:pkey]].to_s
          elsif element[:index].include?(:search_key)
            raise 'Links configuration failure' unless element[:index].include?(:for)

            result[element[:fkey]] =
              model.where({ element[:index][:search_key] => element[:index][:for] }).first[element[:pkey]]
          else
            raise 'Links configuration failure'
          end
        end
        result
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
