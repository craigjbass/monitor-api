describe LocalAuthority::Gateway::SequelReturn do
  include_context 'with database'

  let(:gateway) { described_class.new(database: database) }

  context 'example one' do
    let(:project_return) do
      LocalAuthority::Domain::Return.new.tap do |r|
        r.project_id = 1
        r.data = { cats: "meow" }
      end
    end
    let(:return_id) { gateway.create(project_return) }

    before { return_id }

    it 'creates the new return' do
      found_return = gateway.find_by(id: return_id)

      expect(found_return.project_id).to eq(1)
      expect(found_return.data).to eq(cats: "meow")
    end

    it 'updates the return' do
      project_return.id = return_id
      project_return.data = { dogs: 'woof' }

      gateway.update(project_return)

      found_return = gateway.find_by(id: return_id)

      expect(found_return.data).to eq(dogs: 'woof')
    end
  end

  context 'example two' do
    let(:project_return) do
      LocalAuthority::Domain::Return.new.tap do |r|
        r.project_id = 5
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

    it 'creates the new return' do
      found_return = gateway.find_by(id: return_id)

      expect(found_return.project_id).to eq(5)
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

    it 'updates the return' do
      project_return.id = return_id
      project_return.data[:animals] << {cow: 'moo'}

      gateway.update(project_return)

      found_return = gateway.find_by(id: return_id)

      expect(found_return.data).to eq(
        animals: [
          { cat: 'meow' },
          { dog: { angry: 'bark', happy: 'woof' } },
          { cow: 'moo' }
        ]
      )
    end
  end
end

