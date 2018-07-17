RSpec.shared_context 'use case factory' do
  def get_use_case(use_case)
    use_case_factory.get_use_case(use_case)
  end

  let(:use_case_factory) do
    factory = ::UseCaseFactory.new
    factory.default_dependencies
    factory
  end
end
