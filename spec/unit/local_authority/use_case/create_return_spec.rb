# frozen_string_literal: true

require 'rspec'

describe LocalAuthority::UseCase::CreateReturn do
  let(:return_gateway) { spy(create: {}) }
  let(:create_return) { described_class.new(return_gateway: return_gateway) }
  it 'can be created' do
    described_class.new(return_gateway: return_gateway)
  end

  context 'example one' do
    let(:return_hash) { {project_id: 0, data: { summary: { name: 'Cats' } } } }
    let(:return_gateway) { spy(create: 1) }
    it 'returns a return_id' do
      id = create_return.execute(return_hash)
      expect(id).to eq(id: 1)
    end

    context 'creates a return via the gateway' do
      it 'passes the id to the gateway' do
        create_return.execute(return_hash)
        expect(return_gateway).to have_received(:create) do |return_object|
          expect(return_object.project_id).to eq(0)
        end
      end

      it 'passes the return to the gateway' do
        create_return.execute(return_hash)
        expect(return_gateway).to have_recieved(:create) do |return_object|
          expect(return_object.data).to eq(summary: { name: 'Cats' })
        end
      end

      it 'passes the id and return to the gateway' do
        create_return.execute(return_hash)
        expect(return_gateway).to have_recieved(:create) do |return_object|
          expect(return_object.project_id).to eq(0)
          expect(return_object.data).to eq(summary: { name: 'Cats' })
        end
      end
    end
  end

  context 'example two' do
    let(:return_hash) { {project_id: 255, data: { summary: { name: 'Cats' } } } }
    let(:return_gateway) { spy(create: 480) }
    it 'returns a return_id' do
      id = create_return.execute(return_hash)
      expect(id).to eq(id: 480)
    end

    context 'creates a return via the gateway' do
      it 'passes the id to the gateway' do
        create_return.execute(return_hash)
        expect(return_gateway).to have_received(:create) do |return_object|
          expect(return_object.project_id).to eq(255)
        end
      end

      it 'passes the return to the gateway' do
        create_return.execute(return_hash)
        expect(return_gateway).to have_recieved(:create) do |return_object|
          expect(return_object.data).to eq(summary: { name: 'Cats' })
        end
      end

      it 'passes the id and return to the gateway' do
        create_return.execute(return_hash)
        expect(return_gateway).to have_recieved(:create) do |return_object|
          expect(return_object.project_id).to eq(255)
          expect(return_object.data).to eq(summary: { name: 'Cats' })
        end
      end
    end
  end
end
