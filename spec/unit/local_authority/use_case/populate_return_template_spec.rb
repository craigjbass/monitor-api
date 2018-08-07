# frozen_string_literal: true

describe LocalAuthority::UseCase::PopulateReturnTemplate do
  let(:template) do
    LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
      p.layout = {
        infrastructure: [
          {
            submissionEstimated: 1
          }
        ]
      }
    end
  end
  let(:project_type) {'hif'}
  let(:baseline) do
    {
      infrastructure: [
        {
          targetSubmission: 1
        }
      ]
    }
  end

  let(:template_gateway_spy) { spy(find_by: template) }
  let(:use_case) { described_class.new(template_gateway: template_gateway_spy) }
  let(:response) { use_case.execute(type: project_type, data: baseline) }

  before { response }

  it do
  end
end
