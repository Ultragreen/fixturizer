namespace :fixturizer do
  namespace :database do

    desc "Drop database"
    task :drop do
      Fixturizer::Engines::Models::new(filename: './config/rules.yml').drop_database
    end

    desc "Populate database"
    task :populate do
      Fixturizer::Engines::Models::new(filename: './config/rules.yml').populate

    end

    desc "Check database connection"
    task :check do
      puts (Fixturizer::E0ngines::Models::new(filename: './config/rules.yml').check)? 'OK': 'KO'
    end

  end
end