module Fixturizer
  module Engines
    class Models
      ADAPTERS = { mongoid: ::Fixturizer::Adapters::Mongoid }

      attr_reader :generated

      def initialize
        @configuration = Fixturizer::Services.get.configuration
        @rules = @configuration.rules
        @models = @configuration.models
        @order = @configuration.models_order
        @type = @configuration.models_type
        @generated = {}
        extend ADAPTERS[@type]
      end

      def populate
        generate_data
        inject_data
        true
      end

      def generate_data
        @generated.clear
        raise 'Order field format missmatch, not an array' unless @order.nil? || @order.is_a?(Array)

        if @order
          raise 'Order field size missmatch for configurate definitions' unless @order.size == @models.size

          @order.each do |item|
            raise "Definition #{item} not found in models definitions" unless @models.include?(item)

            @generated[item] = generate_collection(name: item)
          end
        else
          @models.each do |key, _value|
            @generated[key] = generate_collection(name: key)
          end
        end
      end

      def inject_data
        raise 'Data not generated' if @generated.empty?

        @generated.each do |key, value|
          model_infos = @models[key].dup
          model_infos.delete(:collection)
          value.each do |item|
            item[:attributes].merge!(binder(item: item[:links])) if item.include?(:links)
            injector model_infos:, item: item[:attributes]
          end
        end
      end

      private

      def generate_collection(name:)
        data = @models[name][:collection].dup
        data.each do |item|
          dataset = {}
          dataset[:definition] = item[:attributes]
          dataset[:rules] = @models[name][:rules]
          item[:attributes] =
            Fixturizer::Services.get.engine(name: :dataset, parameters: { dataset: }).generate
        end
        data
      end
    end
  end
end
