require 'active_record'
require 'yaml'
require 'logger'

namespace :db do
  
  DBCONF_FILE = "./db/config/database.yml"
  MIGRATIONS_DIR = "./db/migrate"

  dbconf = YAML.load_file(DBCONF_FILE)
  ActiveRecord::Base.establish_connection(
    dbconf["development"]
  )

  # output logs
  ActiveRecord::Base.logger = Logger.new(STDOUT)


  desc "Migrate Database"
  task :migrate do
    ActiveRecord::Migrator.migrate(
      MIGRATIONS_DIR,
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
  end

  desc "Roll back the database schema to the previous version"
  task :rollback do
    ActiveRecord::Migrator.rollback(
      MIGRATIONS_DIR,
      ENV['STEP'] ? ENV['STEP'].to_i : 1
    )
  end
end



