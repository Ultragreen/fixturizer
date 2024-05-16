# frozen_string_literal: true

namespace :fixturizer do
  namespace :database do
    desc 'Drop database'
    task :drop do
      Fixturizer::Services.get.engine(name: :models).drop_database
      puts "Database successfully dropped" if Fixturizer::Services.settings.verbose
    end

    desc 'Populate database'
    task :populate do
      Fixturizer::Services.get.engine(name: :models).populate
      puts "Database successfully populated" if Fixturizer::Services.settings.verbose
    end

    desc 'Check database connection'
    task :check do
      puts Fixturizer::Services.get.engine(name: :models).check ? 'OK' : 'KO'
    end
  end
end
