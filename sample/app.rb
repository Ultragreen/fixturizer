require 'mongoid'
require 'fixturizer'
require_relative 'models/init'

Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))