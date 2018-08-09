# frozen_string_literal: true

describe LocalAuthority::UseCase::PopulateReturnTemplate do
  let(:template) do
    LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
      p.layout = {
        infrastructure: [
          {
            targetSubmission: nil,
            targetGranted: nil,
            grantEstimated: nil,
            submissionEstimated: nil
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
          submissionEstimated: 'baseline data to be copied',
          grantEstimated: 'baseline data baseline data to be copied'
        }
      ]
    }
  end

  let(:template_gateway_spy) { spy(find_by: template) }
  let(:use_case) { described_class.new(template_gateway: template_gateway_spy) }
  let(:response) { use_case.execute(type: project_type, baseline_data: baseline) }

  before { response }

  it 'fetches the template for the given type' do
    expect(template_gateway_spy).to(
      have_received(:find_by).with(type: 'hif')
    )
  end

  it 'will return populated data' do
    p baseline
    expect(response).to eq(populated_data: {
          infrastructure: [
            {
              submissionEstimated: 'baseline data to be copied',
              grantEstimated: 'baseline data baseline data to be copied',
              targetSubmission: 'baseline data to be copied',
              targetGranted: 'baseline data baseline data to be copied'
            }
          ]
        }
      )
  end
end
