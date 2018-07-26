RSpec.shared_context 'use case factory' do
  include_context 'with database'

  def get_use_case(use_case)
    use_case_factory.get_use_case(use_case)
  end

  let(:use_case_factory) do
    factory = ::UseCaseFactory.new
    factory.database = database

    factory.default_dependencies
    factory
  end
end
