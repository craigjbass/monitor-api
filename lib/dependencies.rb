class Dependencies
  def self.use_case_factory
    factory = UseCaseFactory.new

    factory.default_dependencies

    factory
  end
end
