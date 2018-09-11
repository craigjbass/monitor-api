# frozen_string_literal: true

require 'rspec'

describe LocalAuthority::UseCase::GetReturn do
  let(:return_gateway) do
    spy(find_by: return_object)
  end

  let(:return_update_gateway) do
    spy(updates_for: return_updates)
  end

  let(:calculate_return_spy) do
    spy(execute: {calculated_return: {}})
  end

  let(:get_returns_spy) do
    spy(execute: { returns: [] })
  end

  let(:use_case) do
    described_class.new(
      return_gateway: return_gateway,
      return_update_gateway: return_update_gateway,
      calculate_return: calculate_return_spy,
      get_returns: get_returns_spy
    )
  end
  let(:response) { use_case.execute(id: return_id) }

  before { response }

  context 'example one' do
    let(:return_id) { 10 }

    let(:previous_return_hash) do
      {
        id: 9,
        project_id: 0,
        status: 'Submitted',
        updates: [
          { cats: 'meow' }
        ]
      }
    end

    let(:return_hash) do
      {
        id: 10,
        project_id: 0,
        status: 'Draft',
        updates: [
          { dogs: 'woof' }
        ]
      }
    end

    let(:get_returns_spy) do
      spy(
        execute: {
          returns: [
            previous_return_hash,
            return_hash
          ]
        }
      )
    end

    let(:return_object) do
      LocalAuthority::Domain::Return.new.tap do |r|
        r.id = 10
        r.project_id = 0
      end
    end



    let(:return_updates) do
      [
        LocalAuthority::Domain::ReturnUpdate.new.tap do |u|
          u.data = { dogs: 'woof'}
        end
      ]
    end

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
      let(:return_updates) { [] }

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
        expect(response[:updates].length).to eq(1)
        expect(response[:updates].first[:dogs]).to eq('woof')
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
        expect(response[:updates].length).to eq(2)
        expect(response[:updates][0]).to eq(cats: 'meow')
        expect(response[:updates][1][:dogs]).to eq('woof')
      end
    end

    it 'will execute calculate return usecase' do
      expect(calculate_return_spy).to have_received(:execute).with(
        return_data_with_no_calculations: { dogs: 'woof' },
        previous_return: { cats: 'meow' }
      )
    end

    it 'will execute get_returns' do
      expect(get_returns_spy).to have_received(:execute).with(project_id: 0)
    end
    let(:calculate_return_spy) do
      spy(execute: {
        calculated_return: {
          dogs: 'woof',
          infrastructures: {
            planning: {
              planningNotGranted: {
                varianceCalculations: {
                  varianceAgainstLastReturn: {
                    varianceLastReturnFullPlanningPermissionSubmitted: nil
                  }
                }
              }
            }
          }
        }
      })
    end

    it 'will return the calculated data in the latest update' do
      expect(response[:updates][-1]).to eq(
        dogs: 'woof',
        infrastructures: {
          planning: {
            planningNotGranted: {
              varianceCalculations: {
                varianceAgainstLastReturn: {
                  varianceLastReturnFullPlanningPermissionSubmitted: nil
                }
              }
            }
          }
        }
      )
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
    let(:get_returns_spy) do
      spy(
        execute: {
          returns: []
        }
      )
    end

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
      let(:calculate_return_spy) do
        spy(execute: { calculated_return: {dogs: 'woof'} })
      end

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
      let(:calculate_return_spy) do
        spy(execute: {calculated_return: {cows: 'moo'}})
      end

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

    it 'will execute get_returns' do
      expect(get_returns_spy).to have_received(:execute).with(project_id: 1)
    end

    context 'given three returns' do
      let(:initial_return_hash) do
        {
          id: 8,
          project_id: 0,
          status: 'Submitted',
          updates: [
            { cats: 'meow' }
          ]
        }
      end

      let(:previous_return_hash) do
        {
          id: 9,
          project_id: 0,
          status: 'Submitted',
          updates: [
            { cows: 'moo' }
          ]
        }
      end

      let(:return_hash) do
        {
          id: 50,
          project_id: 0,
          status: 'Draft',
          updates: [
            { pigs: 'squeal' }
          ]
        }
      end

      let(:return_updates) do
        [
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { pigs: 'squeal' }
          end
        ]
      end

      let(:get_returns_spy) do
        spy(
          execute: {
            returns: [
              initial_return_hash,
              previous_return_hash,
              return_hash
            ]
          }
        )
      end

      it 'will execute calculate return usecase' do
        expect(calculate_return_spy).to have_received(:execute).with(
          return_data_with_no_calculations: { pigs: 'squeal' },
          previous_return: { cows: 'moo' }
        )
      end

      context 'given a prior draft return' do
        let(:previous_return_hash) do
          {
            id: 9,
            project_id: 0,
            status: 'Draft',
            updates: [
              { cows: 'moo' }
            ]
          }
        end
        it 'does not base data off of a draft' do
          expect(calculate_return_spy).to have_received(:execute).with(
            return_data_with_no_calculations: { pigs: 'squeal' },
            previous_return: { cats: 'meow' }
          )
        end
      end
    end
  end
end
