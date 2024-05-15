require 'fixturizer'

Dir["#{File.dirname(__FILE__)}/helpers/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/matchers/*.rb"].each { |file| require file }