describe LocalAuthority::UseCase::GetBaseReturn do
  let(:project_gateway_spy) { spy(find_by: project) }
  let(:populate_return_spy) { spy(execute: populated_return) }
  let(:use_case) do
    described_class.new(
      populate_return: populate_return_spy,
      project_gateway: project_gateway_spy
    )
  end
  let(:response) { use_case.execute(project_id: project_id) }

  before { response }

  context 'example one' do
    let(:project_id) { 1 }
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'hif'
        p.data = { description: 'Super secret project' }
      end
    end
    let(:populated_return) { { populated_data: { cats: 'Are the coolest' } } }

    it 'will find the project in the Project Gateway' do
      expect(project_gateway_spy).to have_received(:find_by).with(id: 1)
    end

    it 'will pass the project type to the populate return use case' do
      expect(populate_return_spy).to(
        have_received(:execute).with(
          hash_including(type: 'hif')
        )
      )
    end

    it 'will pass the project data to the populate return use case' do
      expect(populate_return_spy).to(
        have_received(:execute).with(
          hash_including(data: { description: 'Super secret project' })
        )
      )
    end

    it 'returns the populated return from the populate return use case' do
      expect(response).to eq(base_return: { cats: 'Are the coolest' })
    end
  end

  context 'example two' do
    let(:project_id) { 42 }
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'Woof'
        p.data = { description: 'Super secret Cat Lab' }
      end
    end

    let(:populated_return) { { populated_data: { dogs: 'are also cool' } } }

    it 'will find the project in the Project Gateway' do
      expect(project_gateway_spy).to have_received(:find_by).with(id: 42)
    end

    it 'will pass the project type to the populate return use case' do
      expect(populate_return_spy).to(
        have_received(:execute).with(
          hash_including(type: 'Woof')
        )
      )
    end

    it 'will pass the project data to the populate return use case' do
      expect(populate_return_spy).to(
        have_received(:execute).with(
          hash_including(data: { description: 'Super secret Cat Lab' })
        )
      )
    end

    it 'returns the populated return from the populate return use case' do
      expect(response).to eq(base_return: { dogs: 'are also cool' })
    end
  end
end
