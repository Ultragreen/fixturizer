require 'mongoid'
require "fixturizer/version"
require 'yaml'

module Fixturizer
  module Adapters
    module Mongoid
      def injector(model_infos:, item:)
        model = Object.const_get(model_infos[:class])
        model.create!(item) unless model.where(model_infos[:unicity] => item[model_infos[:unicity]]).exists?
      end

      def binder(item:)
        result = Hash::new
        item.each do |element|
          model_class = @models[element[:collection]][:class]
          model = Object.const_get(model_class)
          if element[:index].include?(:at)
            result[element[:fkey]] = model.all[element[:index][:at] - 1][element[:pkey]].to_s
          elsif element[:index].include?(:search_key)
            raise 'Links configuration failure' unless element[:index].include?(:for)

            result[element[:fkey]] = model.where({ element[:index][:search_key] => element[:index][:for] }).take[element[:pkey]]
          else
            raise 'Links configuration failure'
          end
        end
        return result
      end

      def drop_database
        ::Mongoid.purge!
      end
    end
  end

  class Engine
    ADAPTERS = {:mongoid => ::Fixturizer::Adapters::Mongoid}

    attr_reader :generated

    def initialize(filename:)
      @rules = read_rules(filename: filename)
      @generations = @rules[:fixtures][:rules][:generation]
      @models = @rules[:fixtures][:models][:definition]
      @order = @rules[:fixtures][:models].include?(:order) ? @rules[:fixtures][:models][:order] : false
      @generated = Hash::new
      self.extend ADAPTERS[@rules[:fixtures][:type]]
    end

    def generate_from(rule:)
      rule = @generations[rule]
      myproc = eval("lambda { #{rule[:proc]} } ")
      return myproc.call
    end

    def link_data
    end

    def generate_data
      @generated.clear
      raise 'Order field format missmatch, not an array' unless @order == false || @order.class == Array

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
    def read_rules(filename:)
      return YAML.load(File::readlines(filename).join)
    end

    def generate_collection(name:)
      data = @models[name][:collection].dup
      data.each do |item|

        item[:attributes].each do |key, _value|
          item[:attributes][key] = generate_from(rule: @models[name][:rules][key]) if @models[name].include?(:rules) && @models[name][:rules].include?(key)
        end

      end
      return data
    end
  end
end
