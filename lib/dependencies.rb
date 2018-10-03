class Dependencies
  def self.dependency_factory
    factory = DependencyFactory.new
    database = DatabaseAdministrator::Postgres.new.existing_database

    factory.database = database

    factory.default_dependencies

    factory
  end
end
