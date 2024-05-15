namespace :fixturizer do
  namespace :database do

    desc "Drop database"
    task :drop do
      my_fixturer = Fixturizer::ModelsEngine::new filename: './config/rules.yml'
      my_fixturer.drop_database
    end

    desc "Populate database"
    task :populate do
      my_fixturer = Fixturizer::ModelsEngine::new filename: './config/rules.yml'
      my_fixturer.generate_data
      my_fixturer.inject_data
    end

  end
end