# frozen_string_literal: true

require 'rspec'

describe LocalAuthority::UseCase::CreateReturn do
  let(:return_gateway) { spy(create: created_return_id) }
  let(:return_update_gateway) { spy(create: nil) }
  let(:create_return) do
    described_class.new(
      return_gateway: return_gateway,
      return_update_gateway: return_update_gateway
    )
  end

  context 'example one' do
    let(:return_hash) { {project_id: 0, data: { summary: { name: 'Cats' } } } }
    let(:created_return_id) { 1 }

    it 'returns a return_id' do
      id = create_return.execute(return_hash)
      expect(id).to eq(id: 1)
    end

    it 'passes the project id to the gateway' do
      create_return.execute(return_hash)
      expect(return_gateway).to have_received(:create) do |return_object|
        expect(return_object.project_id).to eq(0)
      end
    end

    it 'passes the created return id to the return updates gateway' do
      create_return.execute(return_hash)
      expect(return_update_gateway).to have_received(:create) do |update|
        expect(update.return_id).to eq(1)
      end
    end

    it 'passes the return data to the return updates gateway' do
      create_return.execute(return_hash)
      expect(return_update_gateway).to have_received(:create) do |update|
        expect(update.data).to eq(summary: { name: 'Cats' })
      end
    end
  end

  context 'example two' do
    let(:return_hash) { {project_id: 255, data: { summary: { name: 'Dogs' } } } }
    let(:created_return_id) { 480 }

    it 'returns a return_id' do
      id = create_return.execute(return_hash)
      expect(id).to eq(id: 480)
    end

    it 'passes the id to the gateway' do
      create_return.execute(return_hash)
      expect(return_gateway).to have_received(:create) do |return_object|
        expect(return_object.project_id).to eq(255)
      end
    end

    it 'passes the created return id to the return updates gateway' do
      create_return.execute(return_hash)
      expect(return_update_gateway).to have_received(:create) do |update|
        expect(update.return_id).to eq(480)
      end
    end

    it 'passes the return data to the return updates gateway' do
      create_return.execute(return_hash)
      expect(return_update_gateway).to have_received(:create) do |update|
        expect(update.data).to eq(summary: { name: 'Dogs' })
      end
    end
  end
end
