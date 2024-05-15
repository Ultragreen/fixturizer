module Fixturizer
    module Engines
        class Models
            ADAPTERS = {:mongoid => ::Fixturizer::Adapters::Mongoid}
            
            attr_reader :generated
            
            def initialize(filename:)
                @configuration = Fixturizer::Configuration::new filename: './config/rules.yml'
                @rules = @configuration.rules
                @models = @configuration.models
                @order = @configuration.models_order
                @type = @configuration.models_type
                @generated = Hash::new
                self.extend ADAPTERS[@type]
            end
            
            
            def populate
                generate_data
                inject_data
                return true
            end
            
            def generate_data
                @generated.clear
                raise 'Order field format missmatch, not an array' unless @order.nil? || @order.is_a?(Array)
                if @order then
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
                        item[:attributes].merge!(self.binder(item: item[:links])) if item.include?(:links)
                        self.injector model_infos: model_infos, item: item[:attributes]
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
                    item[:attributes] = Fixturizer::Engines::Dataset::new(dataset: dataset).generate
                end
                return data
            end
            
            
        end
    end
end
