# frozen_string_literal: true

require 'yaml'

module Fixturizer
  class Configuration
    attr_reader :rules, :models, :datasets, :models_order, :models_type

    def initialize(filename:)
      @content = read_file(filename:)
      @rules = @content[:fixtures][:rules]
      @models_type = @content[:fixtures].dig(:models, :type)
      @models = @content[:fixtures].dig(:models, :definitions)
      @models_order = @content[:fixtures].dig(:models, :order)
      @datasets = @content[:fixtures][:datasets]
    end

    private

    def read_file(filename:)
      YAML.load(File.readlines(filename).join)
    end
  end

  class ConfigurationLinter
    attr_reader :content
    
    def initialize(path:'/tmp/rules.yml')
      @status = {status: :ok, warn: [], error: [], cleaned: []}
      @path = path
    end
    
    
    

    def validate!
      begin
        @content = read_file filename: @path
        [:validate_root,:validate_section, :validate_rules,:validate_datasets].each do |method|
          p @status[:status] = :ok
          self.send method if @status[:status] = :ok
        end
      rescue RuntimeError
        @status[:status] = :ko
        @status[:error].push "Malformed YAML file"
      rescue  Errno::ENOENT
        @status[:status] = :ko
        @status[:error].push "Missing YAML file"
      rescue  NoMethodError
        @status[:status] = :ko
      end
      
      return @status
    end


    private
    def read_file(filename:)
      YAML.load(File.readlines(filename).join)
    end

    def validate_root
      if @content.dig(:fixtures).nil? 
        @status[:error].push "General root error : key is not Symbol :fixtures or empty" 
        @status[:status] = :ko
      end
    end

    def validate_section
      full_nil = []
      [:datasets,:rules,:models].each do |root|
        unless @content.dig(:fixtures, root).is_a? Hash or @content.dig(:fixtures,root).nil?
          @status[:error].push "//:fixtures/#{root} is not a Hash" 
          @status[:status] = :ko
        end
        full_nil.push root if @content.dig(:fixtures,root).nil?
      end
      if full_nil.size == 3 
        @status[:error].push "All sections are empty  : #{full_nil}" 
          @status[:status] = :ko
      end
    end

    def validate_rules
      return if @content.dig(:fixtures,:rules).nil?
      count = @status[:error].size
      @content.dig(:fixtures,:rules).each do |name, rule|
        @status[:error].push "//:fixtures/:rules/:#{name} is not a Symbol" unless name.is_a? Symbol
        @status[:error].push "//:fixtures/:rules/:#{name} record is not a Hash" unless rule.is_a? Hash 
        @status[:error].push "//:fixtures/:rules/:#{name} not have key :proc defined" unless rule.include? :proc
        @status[:error].push "//:fixtures/:rules/:#{name}/:proc is not a String" unless rule[:proc].is_a? String
        if rule.include? :preserve then
          @status[:error].push "//:fixtures/:rules/:#{name} have key :preserve but it's not a Boolean" unless [true, false].include? rule[:preserve]
        end
      end
      @status[:status] = (@status[:error].size > count)? :ko : @status[:status]
    end


    def validate_datasets
      return if @content.dig(:fixtures,:datasets).nil?
      count = @status[:error].size
      @content.dig(:fixtures,:datasets).each do |name, dataset|
        @status[:error].push "//:fixtures/:datasets/:#{name} is not a Symbol" unless name.is_a? Symbol
        @status[:error].push "//:fixtures/:datasets/:#{name} record is not a Hash" unless dataset.is_a? Hash
        @status[:error].push "//:fixtures/:datasets/:#{name} not have key :definition defined" unless dataset.include? :definition
        @status[:error].push "//:fixtures/:datasets/:#{name}/:definition is nil" if dataset[:definition].nil?
        if dataset.include? :rules then
          @status[:error].push "//:fixtures/:datasets/:#{name} have key :rules but it's not a Hash" unless dataset[:rules].is_a? Hash
          dataset[:rules].each do |key,value|
            @status[:error].push "//:fixtures/:datasets/:#{name}/:rules/#{key} is not a Symbol" unless key.is_a? Symbol
            unless value.is_a? Symbol
              @status[:error].push "//:fixtures/:datasets/:#{name}/:rules/#{key} value (#{value}) is not a Symbol" 
            else
              @status[:warn].push "//:fixtures/:datasets/:#{name}/:rules/#{key} is useless" if nested_hash_value(dataset[:definition],key).nil?
            end
            @status[:error].push "//:fixtures/:datasets/:#{name}/:rules/#{key} set but no rules exist" unless @content.dig(:fixtures,:rules).include? value
            
          end
          
        end
      end
      @status[:status] = (@status[:error].size > count)? :ko : @status[:status]
    end


    def nested_hash_value(obj,key)
      if obj.respond_to?(:key?) && obj.key?(key)
        obj[key]
      elsif obj.respond_to?(:each)
        r = nil
        obj.find{ |*a| r=nested_hash_value(a.last,key) }
        r
      end
    end

  end

end


p Fixturizer::ConfigurationLinter::new.validate!