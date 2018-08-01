describe HomesEngland::UseCase::GetSchemaForProject do
  let(:template_gateway_spy) { spy(get_template: template) }
  let(:use_case) { described_class.new(template_gateway: template_gateway_spy) }
  let(:response) { use_case.execute(type: type) }

  before { response }

  context 'Example one' do
    let(:template) do
      HomesEngland::Domain::Template.new.tap do |t|
        t.schema = { cats: 'meow' }
      end
    end
    let(:type) { 'hif' }

    it 'Gets the template from the gateway' do
      expect(template_gateway_spy).to(
        have_received(:get_template).with(type: 'hif')
      )
    end

    it 'Returns the schema from the template' do
      expect(response[:schema]).to eq(cats: 'meow')
    end
  end

  context 'Example two' do
    let(:template) do
      HomesEngland::Domain::Template.new.tap do |t|
        t.schema = { dogs: 'woof' }
      end
    end
    let(:type) { 'abc' }

    it 'Gets the template from the gateway' do
      expect(template_gateway_spy).to(
        have_received(:get_template).with(type: 'abc')
      )
    end

    it 'Returns the schema from the template' do
      expect(response[:schema]).to eq(dogs: 'woof')
    end
  end
end

