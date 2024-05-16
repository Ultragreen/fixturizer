namespace :fixturizer do
  namespace :database do

    desc "Drop database"
    task :drop do
      Fixturizer::Services.get.engine(name: :models).drop_database
      #Fixturizer::Engines::Models::new(filename: './config/rules.yml').drop_database
    end

    desc "Populate database"
    task :populate do
      Fixturizer::Services.get.engine(name: :models).populate
    end

    desc "Check database connection"
    task :check do
      puts (Fixturizer::Services.get.engine(name: :models).check)? 'OK': 'KO'
    end

  end
end