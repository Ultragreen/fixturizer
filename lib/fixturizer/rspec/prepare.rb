require 'fixturizer'

Dir["#{File.dirname(__FILE__)}/helpers/*.rb"].each { |file| require file unless File.basename(file) == 'prepare.rb' }