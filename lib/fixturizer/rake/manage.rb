require 'fixturizer'
Dir[File.dirname(__FILE__) + '/rules/*.rake'].each {|file| load file }
