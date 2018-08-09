class LocalAuthority::UseCase::PopulateReturnTemplate
  def initialize(template_gateway:)
    @template_gateway = template_gateway
  end

  def execute(type:, baseline_data:)
    populated_data = @template_gateway.find_by(type: 'hif').layout

    populated_data[:infrastructure][0][:targetSubmission] = baseline_data[:infrastructure][0][:submissionEstimated]
    populated_data[:infrastructure][0][:targetGranted] = baseline_data[:infrastructure][0][:grantEstimated]
    populated_data[:infrastructure][0][:submissionEstimated] = baseline_data[:infrastructure][0][:submissionEstimated]
    populated_data[:infrastructure][0][:grantEstimated] = baseline_data[:infrastructure][0][:grantEstimated]

    {
      populated_data: populated_data
    }
  end

  private

  def populate_hash(base, data)
    base.each do |key, value|
      next if data[key].nil?
      base[key] = get_data_value(base, data, key, value)
    end
  end

  def get_data_value(base, data, key, value)
    case base[key]
    when Hash
      populate_hash(value, data[key])
    else
      data[key]
    end
  end
end
