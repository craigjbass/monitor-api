# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Validates HIF return' do
  include_context 'dependency factory'

  context 'Invalid HIF return' do
    # percent complete set to > 100
    let(:project_base_return) do
      JSON.parse(
        File.open("#{__dir__}/../../fixtures/base_return.json").read,
        symbolize_names: true
      )
    end

    it 'should return valid if it passes validation' do
      valid_return = get_use_case(:validate_return).execute(type: 'hif', return_data: project_base_return)
      expect(valid_return[:valid]).to eq(true)
      expect(valid_return[:invalid_paths]).to eq([])
      expect(valid_return[:pretty_invalid_paths]).to eq([])
    end
  end
end
