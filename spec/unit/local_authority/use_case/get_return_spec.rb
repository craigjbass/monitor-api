# frozen_string_literal: true

require 'rspec'

describe LocalAuthority::UseCase::GetReturn do
  let(:return_gateway) do
    spy(find_by: return_object)
  end

  let(:return_update_gateway) do
    spy(updates_for: return_updates)
  end

  let(:use_case) do
    described_class.new(
      return_gateway: return_gateway,
      return_update_gateway: return_update_gateway
    )
  end
  let(:response) { use_case.execute(id: return_id) }

  before { response }

  context 'example one' do
    let(:return_id) { 10 }
    let(:return_object) do
      LocalAuthority::Domain::Return.new.tap do |r|
        r.id = 10
        r.project_id = 0
      end
    end
    let(:return_updates) { [] }


    it 'will pass the correct id to the return gateway' do
      expect(return_gateway).to have_received(:find_by).with(id: 10)
    end

    it 'will find the updates for the correct return' do
      expect(return_update_gateway).to have_received(:updates_for).with(return_id: 10)
    end

    it 'will return the return from the gateway' do
      expect(response[:id]).to eq(10)
      expect(response[:project_id]).to eq(0)
      expect(response[:status]).to eq('Draft')
    end

    context 'given no updates' do
      it 'returns an empty array' do
        expect(response[:updates]).to eq([])
      end
    end

    context 'given one update' do
      let(:return_updates) do
        [
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { cats: 'meow' }
          end
        ]
      end

      it 'returns an array with one hash' do
        expect(response[:updates]).to eq([{ cats: 'meow' }])
      end
    end

    context 'given two updates' do
      let(:return_updates) do
        [
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { cats: 'meow' }
          end,
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { dogs: 'woof' }
          end
        ]
      end

      it 'returns an array with two hashes' do
        expect(response[:updates]).to eq([{ cats: 'meow' },{dogs: 'woof'}])
      end
    end
  end

  context 'example two' do
    let(:return_id) { 50 }
    let(:return_object) do
      return_object = LocalAuthority::Domain::Return.new.tap do |r|
        r.id = 50
        r.project_id = 1
        r.status = 'Submitted'
      end
    end
    let(:return_updates) { [] }

    it 'will pass the correct id to the return gateway' do
      expect(return_gateway).to have_received(:find_by).with(id: 50)
    end

    it 'find the updates for the correct return' do
      expect(return_update_gateway).to have_received(:updates_for).with(return_id: 50)
    end

    it 'will return the return from the gateway' do
      expect(response[:id]).to eq(50)
      expect(response[:project_id]).to eq(1)
      expect(response[:status]).to eq('Submitted')
    end

    context 'given no updates' do
      it 'returns an empty array' do
        expect(response[:updates]).to eq([])
      end
    end

    context 'given one update' do
      let(:return_updates) do
        [
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { dogs: 'woof' }
          end
        ]
      end

      it 'returns an array with one hash' do
        expect(response[:updates]).to eq([{ dogs: 'woof' }])
      end
    end

    context 'given two updates' do
      let(:return_updates) do
        [
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { ducks: 'quack' }
          end,
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { cows: 'moo' }
          end
        ]
      end

      it 'returns an array with two hashes' do
        expect(response[:updates]).to eq([{ ducks: 'quack' }, { cows: 'moo' }])
      end
    end
  end
end
