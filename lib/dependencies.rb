class Dependencies
  def self.use_case_factory
    factory = UseCaseFactory.new
    database = DatabaseAdministrator::Postgres.new.existing_database

    factory.database = database

    factory.default_dependencies

    factory
  end
end
