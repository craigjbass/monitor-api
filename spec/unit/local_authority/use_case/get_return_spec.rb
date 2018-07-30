# frozen_string_literal: true

require 'rspec'

describe LocalAuthority::UseCase::GetReturn do
  let(:return_gateway) do
    spy(find_by: return_object)
  end

  let(:use_case) { described_class.new(return_gateway: return_gateway) }
  let(:response) { use_case.execute(id: return_id) }

  before { response }

  context 'example one' do
    let(:return_id) { 10 }
    let(:return_object) do
      return_object = LocalAuthority::Domain::Return.new.tap do |r|
        r.id = 10
        r.project_id = 0
        r.data = { cats: 'Jerry' }
      end
    end

    it 'will pass the correct id to the return gateway' do
      expect(return_gateway).to have_received(:find_by).with(id: 10)
    end

    it 'will return the object from get_return' do
      expect(response[:id]).to eq(10)
      expect(response[:project_id]).to eq(0)
      expect(response[:data]).to eq(cats: 'Jerry')
    end
  end

  context 'example two' do
    let(:return_id) { 50 }
    let(:return_object) do
      return_object = LocalAuthority::Domain::Return.new.tap do |r|
        r.id = 50
        r.project_id = 1
        r.data = { cats: 'Tom' }
      end
    end

    it 'will pass the correct id to the return gateway' do
      expect(return_gateway).to have_received(:find_by).with(id: 50)
    end

    it 'will return the object from get_return' do
      expect(response[:id]).to eq(50)
      expect(response[:project_id]).to eq(1)
      expect(response[:data]).to eq(cats: 'Tom')
    end
  end
end
