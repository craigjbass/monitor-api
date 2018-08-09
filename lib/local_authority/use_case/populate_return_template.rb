class LocalAuthority::UseCase::PopulateReturnTemplate
  def initialize(template_gateway:)
    @template_gateway = template_gateway
  end

  def execute(type:, baseline_data:)
  end

  private

  def find_in_baseline(baseline_data, path)
  end
end
