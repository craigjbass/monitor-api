require 'sequel'

module DatabaseAdministrator
  class Postgres
    def initialize
      @migrator = Migrator.new
    end

    def fresh_database
      database = existing_database

      @migrator.destroy(database)
      @migrator.migrate(database)

      database
    end

    def existing_database
      database = Sequel.connect(ENV['DATABASE_URL'])

      load_extensions_for(database)

      @migrator.migrate(database)
      database
    end

    private

    def load_extensions_for(database)
      database.extension :pg_json
    end
  end
end

