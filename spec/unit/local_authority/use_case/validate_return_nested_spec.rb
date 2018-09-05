describe LocalAuthority::UseCase::ValidateReturn do
  let(:project_type) { 'hif' }
  let(:template) do
    LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
      p.schema = {}
    end
  end

  let(:return_template_gateway_spy) { double(find_by: template) }
  let(:use_case) do
    described_class.new(return_template_gateway: return_template_gateway_spy)
  end

end
