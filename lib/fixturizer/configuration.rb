# frozen_string_literal: true

require 'yaml'

module Fixturizer
  class Configuration
    attr_reader :rules, :models, :datasets, :models_order, :models_type, :filename

    def initialize(filename:)
      @filename = filename
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
    
    KEYS_BY_LEVEL = {:fixtures => [:rules,:models,:datasets],
                     :dataset => [:definition, :rules],
                     :models => [:type, :order, :definitions],
                     :model_definition => [:rules,:class,:unicity, :collection],
                     :collection => [:attributes,:links]

    }
  

    def initialize(filename:)
      @status = {status: :ok, warn: [], error: [], cleaned: []}
      @filename = filename
    end
    
    
    def display
      puts "Running linter for Configuration file : #{@filename} :"
      validate
      puts " => Status : #{@status[:status].to_s.upcase} "
      unless @status[:error].empty? then 
        puts "Errors : "
        @status[:error].each do |error|
          puts " * #{error}"
        end
      end
      unless @status[:warn].empty? then 
        puts "Warnings : "
        @status[:warn].each do |warning|
          puts " * #{warning}"
        end
      end
    end
    

    def validate!
      validate
      unless @status[:status] == :ok
        puts "Configuration error, run rake fixturizer:configuration:lint to show"  
        exit 10
      end
    end


    private

    def validate
      begin
        @content = read_file filename: @filename
        [:validate_root,:validate_section, :validate_rules,:validate_datasets,:validate_models].each do |method|
          self.send method if @status[:status] = :ok
        end
      rescue RuntimeError => e
        @status[:status] = :ko
        @status[:error].push "Malformed YAML file #{e.message}"
      rescue  Errno::ENOENT
        @status[:status] = :ko
        @status[:error].push "Missing YAML file"
      rescue  NoMethodError => e
        @status[:status] = :ko
        @status[:error].push "Malformed YAML file #{e.message}"
      end
      return @status
    end

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
              @status[:warn].push "//:fixtures/:datasets/:#{name}/:rules/#{key} is useless" if deep_find_key(key,dataset[:definition]).empty?
            end
            @status[:error].push "//:fixtures/:datasets/:#{name}/:rules/#{key} set but no rules exist" unless @content.dig(:fixtures,:rules).include? value
            
          end
          
        end
      end
      @status[:status] = (@status[:error].size > count)? :ko : @status[:status]
    end


    def validate_models
      return if @content.dig(:fixtures,:models).nil?
      count = @status[:error].size
      model_config = @content.dig(:fixtures,:models)
      unless model_config.is_a? Hash
        @status[:error].push "//:fixtures/:models record is not a Hash" 
      else
        @status[:error].push "//:fixtures/:models/ not have key :type defined" unless model_config.include? :type
        @status[:error].push "//:fixtures/:models/:type is not a symbol" unless model_config[:type].is_a? Symbol
        @status[:error].push "//:fixtures/:models/ not have key :definitions defined" unless model_config.include? :definitions
        unless model_config[:definitions].is_a? Hash then 
          @status[:error].push "//:fixtures/:models/:definitions is not a Hash" 
        else
          @content.dig(:fixtures,:models,:definitions).each do |name, definitions|
            @status[:error].push "//:fixtures/:models/:definitions/:#{name} is not a Symbol" unless name.is_a? Symbol
            @status[:error].push "//:fixtures/:models/:definitions/:#{name} not have key :class defined" unless definitions.include? :class
            @status[:error].push "//:fixtures/:models/:definitions/:#{name}/:class is not a String" unless definitions[:class].is_a? String
            @status[:error].push "//:fixtures/:models/:definitions/:#{name} not have key :unicity defined" unless definitions.include? :unicity
            @status[:error].push "//:fixtures/:models/:definitions/:#{name}/:unicity is not a Symbol" unless definitions[:unicity].is_a? Symbol
            if definitions.include? :rules then
              @status[:error].push "//:fixtures/:models/:definitions/:#{name} have key :rules but it's not a Hash" unless definitions[:rules].is_a? Hash
              definitions[:rules].each do |key,value|
                @status[:error].push "//:fixtures/:models/:definitions/:#{name}/:rules/#{key} is not a Symbol" unless key.is_a? Symbol
                unless value.is_a? Symbol
                  @status[:error].push "//:fixtures/:models/:definitions/:#{name}/:rules/#{key} value (#{value}) is not a Symbol" 
                else
                  @status[:warn].push "//:fixtures/:models/:definitions/:#{name}/:rules/#{key} is useless" if deep_find_key(key,definitions[:collection]).empty?
                end
                @status[:error].push "//:fixtures/:models/:definitions/:#{name}/:rules/#{key} set but no rules exist" unless @content.dig(:fixtures,:rules).include? value
              end
            end
            
            @status[:error].push "//:fixtures/:models/:definitions/:#{name} not have key :collection defined" unless definitions.include? :collection
            @status[:error].push "//:fixtures/:models/:definitions/:#{name}/:collection is not a Array" unless definitions[:collection].is_a? Array
            if definitions.include? :collection then
              definitions.dig(:collection).each_with_index do |record,i|
                @status[:error].push "//:fixtures/:models/:definitions/:#{name}/:collection[#{i}] not have key :attributes defined" unless record.include? :attributes
                @status[:error].push "//:fixtures/:models/:definitions/:#{name}/:collection[#{i}]/:attributes is not a Hash" unless record[:attributes].is_a? Hash
                if record.include? :link
                  unless record[:link].is_a? Hash then
                    @status[:error].push "//:fixtures/:models/:definitions/:#{name}/:collection[#{i}]/:link is set but is not a Hash" 
                  else
                    {to: Symbol, by: Symbol, search_by: Hash}.each do |verb,type|
                      @status[:error].push "//:fixtures/:models/:definitions/:#{name}/:collection[#{i}]/:link not have key :#{verb} defined" unless record[:link].include? verb
                      @status[:error].push "//:fixtures/:models/:definitions/:#{name}/:collection[#{i}]/:link/:#{verb} is not a #{type}" unless record[:link][verb].is_a? type
                    end
                  end
                end
              end
            end
          end
        end
      end
      @status[:status] = (@status[:error].size > count)? :ko : @status[:status]
    end

    def deep_find_key(key, object)
      found = []
      if object.respond_to?(:key?) && object.key?(key)
        found << key
      end
      if object.is_a? Enumerable
        found << object.collect { |*a| deep_find_key(key, a.last) }
      end
      found.flatten.compact
    end

    


  end

end


