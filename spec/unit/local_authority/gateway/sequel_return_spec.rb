describe LocalAuthority::Gateway::SequelReturn do
  include_context 'with database'

  let(:gateway) { described_class.new(database: database) }

  let(:return_update_gateway) do
    LocalAuthority::Gateway::SequelReturnUpdate.new(database: database)
  end

  context 'example one' do
    let(:project_return) do
      LocalAuthority::Domain::Return.new.tap do |r|
        r.project_id = 1
        r.status = 'Draft'
      end
    end
    let(:return_id) { gateway.create(project_return) }

    before { return_id }
    it 'finds the created return' do
      found_return = gateway.find_by(id: return_id)

      expect(found_return.project_id).to eq(1)
      expect(found_return.status).to eq('Draft')
    end
  end

  context 'example two' do
    let(:project_return) do
      LocalAuthority::Domain::Return.new.tap do |r|
        r.project_id = 3
        r.status = 'Submitted'
      end
    end
    let(:return_id) { gateway.create(project_return) }

    before { return_id }

    it 'finds the created return' do
      found_return = gateway.find_by(id: return_id)

      expect(found_return.project_id).to eq(3)
      expect(found_return.status).to eq('Submitted')
    end
  end
end
