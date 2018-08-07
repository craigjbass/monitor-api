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

    it 'soft updates the new return' do
      gateway.soft_update(return_id: return_id, return_data: {cats: "Meow"})
      expect(gateway.find_by(id: return_id)).to eq(1)
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
  end
end