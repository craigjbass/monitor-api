# frozen_string_literal: true

describe LocalAuthority::UseCase::PopulateReturnTemplate do
  let(:template) do
    LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
      p.layout = {
        infrastructure: nil
      }
    end
  end
  let(:project_type) {'hif'}
  let(:baseline) do
    {
      infrastructure: nil
    }
  end

  let(:template_gateway_spy) { spy(find_by: template) }
  let(:use_case) { described_class.new(template_gateway: template_gateway_spy) }
  let(:response) { use_case.execute(type: project_type, data: baseline) }

  before { response }

  it do
  end
end
