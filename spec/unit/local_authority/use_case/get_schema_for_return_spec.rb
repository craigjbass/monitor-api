describe LocalAuthority::UseCase::GetSchemaForReturn do
  let(:project_gateway_spy) { spy(find_by: project) }
  let(:return_gateway_spy) { spy(find_by: found_return) }
  let(:template_gateway_spy) { spy(find_by: template) }

  let(:use_case) do
    described_class.new(
      project_gateway: project_gateway_spy,
      return_gateway: return_gateway_spy,
      template_gateway: template_gateway_spy
    )
  end

  let(:response) { use_case.execute(return_id: return_id) }
  before { response }

  context 'Example one' do
    let(:return_id) { 10 }

    let(:found_return) do
      LocalAuthority::Domain::Return.new.tap do |r|
        r.project_id = 5
      end
    end

    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'hif'
      end
    end

    let(:template) do
      Common::Domain::Template.new.tap do |p|
        p.schema = { cats: 'meow' }
      end
    end

    it 'Gets the return from the return gateway' do
      expect(return_gateway_spy).to have_received(:find_by).with(id: 10)
    end

    it 'Finds the project for the return' do
      expect(project_gateway_spy).to have_received(:find_by).with(id: 5)
    end

    it 'Finds the template for the project type' do
      expect(template_gateway_spy).to have_received(:find_by).with(type: 'hif')
    end

    it 'Returns the schema for the template' do
      expect(response).to eq(schema: { cats: 'meow' })
    end
  end

  context 'Example two' do
    let(:return_id) { 18 }
    let(:found_return) do
      LocalAuthority::Domain::Return.new.tap do |r|
        r.project_id = 9
      end
    end

    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'abc'
      end
    end

    let(:template) do
      Common::Domain::Template.new.tap do |p|
        p.schema = { dogs: 'woof' }
      end
    end

    it 'Gets the return from the return gateway' do
      expect(return_gateway_spy).to have_received(:find_by).with(id: 18)
    end

    it 'Finds the project for the return' do
      expect(project_gateway_spy).to have_received(:find_by).with(id: 9)
    end

    it 'Finds the template for the project type' do
      expect(template_gateway_spy).to have_received(:find_by).with(type: 'abc')
    end

    it 'Returns the schema for the template' do
      expect(response).to eq(schema: { dogs: 'woof' })
    end
  end
end
