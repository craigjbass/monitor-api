describe LocalAuthority::Gateway::SequelReturnUpdate do
  include_context 'with database'

  let(:gateway) { described_class.new(database: database) }

  context '#FindBy' do
    context 'example one' do
      let(:project_return) do
        LocalAuthority::Domain::ReturnUpdate.new.tap do |r|
          r.return_id = 1
          r.data = { cats: "meow" }
        end
      end
      let(:return_id) { gateway.create(project_return) }

      before { return_id }

      it 'creates the new return update' do
        found_return = gateway.find_by(id: return_id)

        expect(found_return.return_id).to eq(1)
        expect(found_return.data).to eq(cats: "meow")
      end
    end

    context 'example two' do
      let(:project_return) do
        LocalAuthority::Domain::ReturnUpdate.new.tap do |r|
          r.return_id = 5
          r.data = {
            animals: [
              { cat: 'meow' },
              {
                dog: {
                  angry: 'bark',
                  happy: 'woof'
                }
              }
            ]
          }
        end
      end
      let(:return_id) { gateway.create(project_return) }

      before { return_id }

      it 'creates the new return update' do
        found_return = gateway.find_by(id: return_id)

        expect(found_return.return_id).to eq(5)
        expect(found_return.data).to eq(
          animals: [
            { cat: 'meow' },
            { dog: {
                angry: 'bark',
                happy: 'woof'
              }
            }
          ]
        )
      end
    end
  end

  context '#UpdatesFor' do
    context 'Example one' do
      let(:update1) do
        LocalAuthority::Domain::ReturnUpdate.new.tap do |r|
          r.return_id = 10
          r.data = {cats: 'meow'}
        end
      end
      let(:update2) do
        LocalAuthority::Domain::ReturnUpdate.new.tap do |r|
          r.return_id = 10
          r.data = {dogs: 'woof'}
        end
      end

      context 'with one update for the return' do
        before { gateway.create(update1) }

        it 'finds the update for the return' do
          found_updates = gateway.updates_for(return_id: 10)

          expect(found_updates.first.data).to eq(cats: 'meow')
        end
      end

      context 'with two updates for the return' do
        before do
          gateway.create(update1)
          gateway.create(update2)
        end

        it 'finds both updates for the return' do
          found_updates = gateway.updates_for(return_id: 10)

          expect(found_updates[0].data).to eq(cats: 'meow')
          expect(found_updates[1].data).to eq(dogs: 'woof')
        end
      end

      context 'with mixed updates from different returns' do
        let(:update3) do
          LocalAuthority::Domain::ReturnUpdate.new.tap do |r|
            r.return_id = 32
            r.data = {bird: 'chirp'}
          end
        end

        before do
          gateway.create(update1)
          gateway.create(update2)
          gateway.create(update3)
        end

        it 'finds only updates for return 10' do
          found_updates = gateway.updates_for(return_id: 10)

          expect(found_updates.length).to eq(2)
          expect(found_updates[0].data).to eq(cats: 'meow')
          expect(found_updates[1].data).to eq(dogs: 'woof')
        end
      end
    end

    context 'Example two' do
      let(:update1) do
        LocalAuthority::Domain::ReturnUpdate.new.tap do |r|
          r.return_id = 77
          r.data = {cows: 'moo'}
        end
      end
      let(:update2) do
        LocalAuthority::Domain::ReturnUpdate.new.tap do |r|
          r.return_id = 77
          r.data = {ducks: 'quack'}
        end
      end

      context 'with one update for the return' do
        before { gateway.create(update1) }

        it 'finds the update for the return' do
          found_updates = gateway.updates_for(return_id: 77)

          expect(found_updates.first.data).to eq(cows: 'moo')
        end
      end

      context 'with two updates for the return' do
        before do
          gateway.create(update1)
          gateway.create(update2)
        end

        it 'finds both updates for the return' do
          found_updates = gateway.updates_for(return_id: 77)

          expect(found_updates[0].data).to eq(cows: 'moo')
          expect(found_updates[1].data).to eq(ducks: 'quack')
        end
      end

      context 'with mixed updates from different returns' do
        let(:update3) do
          LocalAuthority::Domain::ReturnUpdate.new.tap do |r|
            r.return_id = 32
            r.data = {chicken: 'cluck'}
          end
        end

        before do
          gateway.create(update1)
          gateway.create(update2)
          gateway.create(update3)
        end

        it 'finds only updates for return 10' do
          found_updates = gateway.updates_for(return_id: 77)

          expect(found_updates.length).to eq(2)
          expect(found_updates[0].data).to eq(cows: 'moo')
          expect(found_updates[1].data).to eq(ducks: 'quack')
        end
      end
    end
  end
end
