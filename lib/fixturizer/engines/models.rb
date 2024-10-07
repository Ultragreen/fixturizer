# frozen_string_literal: true

module Fixturizer
  module Engines
    class Models
      ADAPTERS = { mongoid: ::Fixturizer::Adapters::Mongoid }.freeze

      attr_reader :generated, :order, :models

      def initialize
        @configuration = Fixturizer::Services.get.configuration
        @models = @configuration.models
        @order = @configuration.models_order
        @type = @configuration.models_type
        @generated = {}
        extend ADAPTERS[@type]
      end

      def populate
        generate
        inject
        true
      end

      def generate
        @generated.clear
        raise 'Order field format missmatch, not an array' unless @order.nil? || @order.is_a?(Array)

        if @order
          raise 'Order field size missmatch for configurate definitions' unless @order.size == @models.size

          @order.each do |item|
            raise "Definition #{item} not found in models definitions" unless @models.include?(item)
            @generated[item]  = generate_collection(name: item)
          end
        else
          @models.each_key do |item|
            @generated[item] = generate_collection(name: item)
          end

        end
      end

      def inject
        raise 'Data not generated' if @generated.empty?
        inject_data
      end

      private

      def generate_collection(name:)
        data = []
        @models[name][:collection].each do |item|
          res = {data: Fixturizer::Services.get.engine(name: :dataset, parameters: { dataset: 
              { definition: item[:attributes], rules: @models[name][:rules]}
               }).generate  }
          belong = item.dig(:belong)
          res[:belong] = belong if belong
          have = item.dig(:have)
          res[:have] = have if have
          data.push res 
          
        end
        return data
      end
    end
  end
end
