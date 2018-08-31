describe LocalAuthority::UseCase::CheckApiKey do
  let(:use_case) { described_class.new }

  def api_key_for_project(project, api_key=ENV['HMAC_SECRET'])
    JWT.encode({project_id: project}, api_key, 'HS512')
  end

  context 'Example one' do
    before { ENV['HMAC_SECRET'] = 'Cats' }

    context 'Given an invalid api key' do
      context 'That is not a JWT token' do
        it 'Returns invalid' do
          response = use_case.execute(api_key: 'cats', project_id: 1)
          expect(response[:valid]).to eq(false)
        end
      end

      context 'That is signed by a different key' do
        it 'returns invalid' do
          api_key = api_key_for_project(1, 'dogs')

          response = use_case.execute(api_key: api_key, project_id: 1)
          expect(response[:valid]).to eq(false)
        end
      end
    end

    context 'given a valid api key' do
      context 'For a different project' do
        it 'Returns invalid' do
          api_key = api_key_for_project(1)

          response = use_case.execute(api_key: api_key, project_id: 5)
          expect(response[:valid]).to eq(false)
        end
      end

      context 'For the correct project' do
        it 'Returns valid' do
          api_key = api_key_for_project(1)

          response = use_case.execute(api_key: api_key, project_id: 1)
          expect(response[:valid]).to eq(true)
        end
      end
    end
  end

  context 'Example two' do
    before { ENV['HMAC_SECRET'] = 'Dogs' }

    context 'Given an invalid api key' do
      context 'That is not a JWT token' do
        it 'Returns invalid' do
          response = use_case.execute(api_key: 'dogs', project_id: 5)
          expect(response[:valid]).to eq(false)
        end
      end

      context 'That is signed by a different key' do
        it 'returns invalid' do
          api_key = api_key_for_project(5, 'meow')

          response = use_case.execute(api_key: api_key, project_id: 5)
          expect(response[:valid]).to eq(false)
        end
      end
    end

    context 'given a valid api key' do
      context 'For a different project' do
        it 'Returns invalid' do
          api_key = api_key_for_project(5)

          response = use_case.execute(api_key: api_key, project_id: 1)
          expect(response[:valid]).to eq(false)
        end
      end

      context 'For the correct project' do
        it 'Returns valid' do
          api_key = api_key_for_project(5)

          response = use_case.execute(api_key: api_key, project_id: 5)
          expect(response[:valid]).to eq(true)
        end
      end
    end
  end
end
