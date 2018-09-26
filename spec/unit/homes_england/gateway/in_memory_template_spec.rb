require 'rspec'

describe HomesEngland::Gateway::InMemoryTemplate do

  let (:template_builder_spy) { spy }
  let(:in_memory_template) {described_class.new(template_builder: template_builder_spy) }

  it 'runs template builder spy with template type' do
    in_memory_template.get_template(type: 'cats')
    expect(template_builder_spy).to have_received(:build_template)
  end
end
