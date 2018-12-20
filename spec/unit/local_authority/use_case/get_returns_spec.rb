require 'rspec'

describe LocalAuthority::UseCase::GetReturns do
  let(:return_gateway) { spy(get_returns: found_returns) }
  let(:return_update_gateway) { spy(updates_for: found_updates) }
  let(:found_returns) { [] }
  let(:found_updates) { [] }

  let(:use_case) do
    described_class.new(
      return_gateway: return_gateway,
      return_update_gateway: return_update_gateway
    )
  end

  context 'example 1' do
    it 'finds all returns for the object' do
      use_case.execute(project_id: 1)
      expect(return_gateway).to have_received(:get_returns).with(project_id: 1)
    end

    context 'Given no returns are found' do
      it 'gets an empty set of matching returns' do
        result = use_case.execute(project_id: 1)
        expect(result).to eq(returns: [])
      end
    end

    context 'Given a single return is found' do
      let(:found_returns) do
        [
          LocalAuthority::Domain::Return.new.tap do |r|
            r.id = 2
            r.project_id = 1
            r.status = 'Draft'
            r.timestamp = 1234
          end
        ]
      end

      let(:found_updates) do
        [
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { cats: 'Meow' }
          end
        ]
      end

      it 'fetches the updates for the return' do
        use_case.execute(project_id: 1)
        expect(return_update_gateway).to have_received(:updates_for).with(return_id: 2)
      end

      it 'gets a single matching return and its updates' do
        response = use_case.execute(project_id: 1)
        expect(response).to eq(
          returns: [
            {
              id: 2,
              project_id: 1,
              status: 'Draft',
              updates: [
                { cats: 'Meow' }
              ],
              timestamp: 1234
            }
          ]
        )
      end

      context 'Given two updates for the return' do
        let(:found_updates) do
          [
            LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
              update.data = { cats: 'Meow' }
            end,
            LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
              update.data = { birds: 'chirp' }
            end
          ]
        end

        it 'gets a single matching return and its updates' do
          response = use_case.execute(project_id: 1)
          expect(response).to eq(
            returns: [
              {
                id: 2,
                project_id: 1,
                status: 'Draft',
                updates: [
                  { cats: 'Meow' },
                  { birds: 'chirp' }
                ],
                timestamp: 1234
              }
            ]
          )
        end
      end
    end

    context 'Given two returns with various numbers of updates' do
      let(:return_update_gateway) do
        Class.new do
          attr_reader :called_with

          def initialize(updates)
            @updates = updates
            @called_with = []
          end

          def updates_for(return_id:)
            @called_with << return_id
            @updates.shift
          end
        end.new(found_updates)
      end

      let(:found_returns) do
        [
          LocalAuthority::Domain::Return.new.tap do |r|
            r.id = 2
            r.project_id = 1
            r.status = 'Draft'
            r.timestamp = 123
          end,
          LocalAuthority::Domain::Return.new.tap do |r|
            r.id = 8
            r.project_id = 6
            r.status = 'Submitted'
            r.timestamp = 321
          end
        ]
      end

      let(:found_updates) do
        [
          [
            LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
              update.return_id = 2
              update.data = { cats: 'Meow' }
            end,
            LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
              update.return_id = 2
              update.data = { birds: 'chirp' }
            end
          ],
          [
            LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
              update.return_id = 8
              update.data = { dogs: 'woof' }
            end,
            LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
              update.return_id = 8
              update.data = { cows: 'moo' }
            end
          ]
        ]
      end

      it 'gets all updates for both returns' do
        use_case.execute(project_id: 1)

        expect(return_update_gateway.called_with[0]).to eq(2)
        expect(return_update_gateway.called_with[1]).to eq(8)
      end

      it 'returns the returns with matching updates' do
        response = use_case.execute(project_id: 1)

        expect(response).to eq(
          returns: [
            {
              id: 2,
              project_id: 1,
              status: 'Draft',
              updates: [
                { cats: 'Meow' },
                { birds: 'chirp' }
              ],
              timestamp: 123
            }, {
              id: 8,
              project_id: 6,
              status: 'Submitted',
              updates: [
                { dogs: 'woof' },
                { cows: 'moo' }
              ],
              timestamp: 321
            }
          ]
        )
      end
    end
  end

  context 'example 2' do
    it 'finds all returns for the object' do
      use_case.execute(project_id: 3)
      expect(return_gateway).to have_received(:get_returns).with(project_id: 3)
    end

    context 'Given no returns are found' do
      it 'gets an empty set of matching returns' do
        result = use_case.execute(project_id: 3)
        expect(result).to eq(returns: [])
      end
    end

    context 'Given a single return is found' do
      let(:found_returns) do
        [
          LocalAuthority::Domain::Return.new.tap do |r|
            r.id = 4
            r.project_id = 3
            r.status = 'Submitted'
            r.timestamp = 987
          end
        ]
      end

      context 'Given a single update for the return' do
        let(:found_updates) do
          [
            LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
              update.data = { dogs: 'woof' }
            end
          ]
        end

        it 'fetches the updates for the return' do
          use_case.execute(project_id: 3)
          expect(return_update_gateway).to have_received(:updates_for).with(return_id: 4)
        end

        it 'gets a single matching return and its updates' do
          response = use_case.execute(project_id: 3)
          expect(response).to eq(
            returns: [
              {
                id: 4,
                project_id: 3,
                status: 'Submitted',
                updates: [
                  { dogs: 'woof' }
                ],
                timestamp: 987
              }
            ]
          )
        end
      end

      context 'Given two updates for the return' do
        let(:found_updates) do
          [
            LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
              update.data = { dogs: 'woof' }
            end,
            LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
              update.data = { cows: 'moo' }
            end
          ]
        end

        it 'gets a single matching return and its updates' do
          response = use_case.execute(project_id: 3)
          expect(response).to eq(
            returns: [
              {
                id: 4,
                project_id: 3,
                status: 'Submitted',
                updates: [
                  { dogs: 'woof' },
                  { cows: 'moo'}
                ],
                timestamp: 987
              }
            ]
          )
        end
      end
    end

    context 'Given two returns with various numbers of updates' do
      let(:found_returns) do
        [
          LocalAuthority::Domain::Return.new.tap do |r|
            r.id = 2
            r.project_id = 1
            r.status = 'Draft'
          end,
          LocalAuthority::Domain::Return.new.tap do |r|
            r.id = 8
            r.project_id = 6
            r.status = 'Submitted'
          end
        ]
      end

      let(:found_updates) do
        [
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.return_id = 2
            update.data = { cats: 'Meow' }
          end,
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.return_id = 2
            update.data = { birds: 'chirp' }
          end
        ]
      end

      it 'gets all updates for both returns' do
        use_case.execute(project_id: 1)

        expect(return_update_gateway).to have_received(:updates_for).twice

        expect(return_update_gateway).to(
          have_received(:updates_for).with(return_id: 2)
        )

        expect(return_update_gateway).to(
          have_received(:updates_for).with(return_id: 8)
        )
      end
    end
  end
end
