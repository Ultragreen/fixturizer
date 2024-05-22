# frozen_string_literal: true

RSpec.describe 'Test Fixturizer' do
  context 'Records : test fixturizing' do
    it 'must be possible to apply non preserving rule by definition' do
      value = 'placeholder'
      rule = { proc: 'SecureRandom.urlsafe_base64(64)' }
      expect(record.apply(value:, rule:).size).to be(86)
    end

    it 'must be possible to apply preserving rule by definition' do
      value = 'present value'
      rule = { proc: 'SecureRandom.urlsafe_base64(64)', preserve: true }
      expect(record.apply(value:, rule:)).to be(value)
    end

    it 'must be possible to apply rule by name (in configuration)' do
      value = 'present value'
      rule = :body
      expect(record.apply(value:, rule:).size).to be(86)
    end
  end

  context 'Datasets : test fixturizing' do
    it 'must be possible to generate result for dataset by definition with named rule' do
      dataset = { definition: { name: 'test dataset', body: 'placeholder' }, rules: { body: :body } }
      result =  datasets.generate(dataset:)
      expect(result[:body].size).to be(86)
      expect(result[:name]).to eq('test dataset')
    end

    it 'must be possible to generate result for dataset by definition with defined rule' do
      dataset = { definition: { name: 'test dataset', body: 'placeholder' },
                  rules: { body: { proc: 'SecureRandom.urlsafe_base64(64)' } } }
      result =  datasets.generate(dataset:)
      expect(result[:body].size).to be(86)
      expect(result[:name]).to eq('test dataset')
    end

    it 'must be possible to generate result for dataset by definition with named rule and nil field' do
      dataset = { definition: { name: 'test dataset', body: nil },
                  rules: { body: :body } }
      result =  datasets.generate(dataset:)
      expect(result[:body].size).to be(86)
      expect(result[:name]).to eq('test dataset')
    end

    it 'must be possible to generate result for dataset by definition with named preserving rule' do
      dataset = { definition: { name: 'test dataset', body: 'test preserved' },
                  rules: { body: :preserve_body } }
      result =  datasets.generate(dataset:)
      expect(result[:body]).to eq('test preserved')
      expect(result[:name]).to eq('test dataset')
    end

    it 'must be possible to generate result for nested dataset by definition with named rule' do
      dataset = { definition: { name: 'test dataset', nested: { body: nil } },
                  rules: { body: :body } }
      result =  datasets.generate(dataset:)
      expect(result[:nested][:body].size).to be(86)
      expect(result[:name]).to eq('test dataset')
    end

    it 'must be possible to generate result for complex dataset by definition with named rule' do
      dataset = { definition: { name: 'test dataset', list: [1, { body: nil }, 3], nested: { body: nil } },
                  rules: { body: :body } }
      result =  datasets.generate(dataset:)
      expect(result[:nested][:body].size).to be(86)
      expect(result[:list].size).to be(3)
      expect(result[:list][1][:body].size).to be(86)
      expect(result[:name]).to eq('test dataset')
    end

    it 'must be possible to generate result for complex dataset by name with named rule' do
      result =  datasets.generate dataset: :myset
      expect(result[0][:nested][:body].size).to be(86)
      expect(result[0][:list].size).to be(3)
      expect(result[0][:list][1][:body].size).to be(86)
      expect(result[0][:name]).to eq('test dataset')
      expect(result.last).to eq('two')
    end
  end

  context 'Database : drop and populate' do
    it 'must be possible to drop database with helper ' do
      expect(database.drop).to be true
    end
    it 'must be possible to populate database with helper ' do
      expect(database.populate).to be true
    end

    it { expect(database).to be_correctly_dropped }
    it { expect(database).to be_correctly_populated }
  end

  context 'Serializers : test ' do
    it 'must be possible to serialize data to JSON' do
      data = { name: 'test data', body: 'placeholder' }
      result = serialize.to(format: :json, data:)
      expect(result).to be_an_instance_of(String)
      expect(result.size).to eq(51)
    end

    it 'must be possible to serialize data to JSON in raw format' do
      data = { name: 'test data', body: 'placeholder' }
      result = serialize.to format: :json, data:, raw: true
      expect(result).to be_an_instance_of(String)
      expect(result.size).to eq(41)
    end

    it 'must be possible to serialize data to JSON and write in a file' do
      data = { name: 'test data', body: 'placeholder' }
      filename = '/tmp/test.json'
      serialize.to format: :json, data:, to_file: filename
      expect(File.exist?(filename)).to eq true
      File.unlink(filename)
    end

    it 'must be possible to serialize data to YAML' do
      data = { name: 'test data', body: 'placeholder' }
      result = serialize.to(format: :yaml, data:)
      expect(result).to be_an_instance_of(String)
      expect(result.size).to eq(40)
    end

    it 'must be possible to serialize data to YAML and write in a file' do
      data = { name: 'test data', body: 'placeholder' }
      filename = '/tmp/test.yml'
      serialize.to format: :yaml, data:, to_file: filename
      expect(File.exist?(filename)).to eq true
      File.unlink(filename)
    end
  end


  context 'Getters : test ' do
    it 'must be possible to get content data from YAML file' do
      filename = './spec/fixtures/data.yml'
      result = get_content.from file: filename, format: :yaml
      expect(result[:body]).to eq "test Body"
      expect(result[:list].size).to eq 3
    end

    it 'must be possible to get content data from YAML file without symbols keys' do
      filename = './spec/fixtures/data.yml'
      result = get_content.from file: filename, format: :yaml, symbolize: false
      expect(result["body"]).to eq "test Body"
      expect(result["list"].size).to eq 3
    end

    it 'must be possible to get content data from JSON file' do
      filename = './spec/fixtures/data.json'
      result = get_content.from file: filename, format: :json
      expect(result[:body]).to eq "test Body"
      expect(result[:list].size).to eq 3
    end

    it 'must be possible to get content data from JSON file without symbols keys' do
      filename = './spec/fixtures/data.json'
      result = get_content.from file: filename, format: :json, symbolize: false
      expect(result["body"]).to eq "test Body"
      expect(result["list"].size).to eq 3
    end

  end


end
