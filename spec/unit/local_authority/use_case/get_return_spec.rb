# frozen_string_literal: true

require 'rspec'

describe LocalAuthority::UseCase::GetReturn do
  let(:return_gateway) do
    spy(get_return: return_object)
  end

  let(:return_object) do
    return_object = LocalAuthority::Domain::Return.new.tap do |r|
      r.project_id = 0
      r.data = { cats: 'Jerry' }
    end
  end

  let(:return_hash) do
    {
      project_id: 0,
      data:  { cats: 'Jerry' }
    }
  end

  let(:use_case) { described_class.new(return_gateway: return_gateway).execute(id: 0) }

  before { @response = use_case }

  it 'will pass the correct id to the return gateway' do
    use_case
    expect(return_gateway).to have_received(:get_return).with(id: 0)
  end

  context 'example one' do
    it 'will return the object from get_return' do
      expect(@response[:project_id]).to eq(0)
      expect(@response[:data]).to eq(cats: 'Jerry')
    end
  end

  context 'example two' do
    let(:return_object) do
      return_object = LocalAuthority::Domain::Return.new.tap do |r|
        r.project_id = 1
        r.data = { cats: 'Tom' }
      end
    end

    let(:return_gateway) do
      spy(get_return: return_object)
    end

    it 'will return the object from get_return' do
      expect(@response[:project_id]).to eq(1)
      expect(@response[:data]).to eq(cats: 'Tom')
    end
  end
end
