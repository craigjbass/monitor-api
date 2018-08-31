describe LocalAuthority::UseCase::CreateApiKey do
  let(:use_case) { described_class.new }

  context 'Example one' do
    before do
      ENV['HMAC_SECRET'] = 'cats'
    end

    it 'Returns an API key' do
      expect(use_case.execute(project_id:  1)[:api_key]).not_to be_nil
    end

    it 'Stores the project id within the api key' do
      api_key = use_case.execute(project_id: 1)[:api_key]

      decoded_key = JWT.decode(
        api_key,
        'cats',
        true,
        algorithm: 'HS512'
      )
      
      expect(decoded_key[0]['project_id']).to eq(1)
    end
  end

  context 'Example two' do
    before do
      ENV['HMAC_SECRET'] = 'dogs'
    end

    it 'Returns an API key' do
      expect(use_case.execute(project_id:  5)[:api_key]).not_to be_nil
    end

    it 'Stores the project id within the api key' do
      api_key = use_case.execute(project_id: 5)[:api_key]

      decoded_key = JWT.decode(
        api_key,
        'dogs',
        true,
        algorithm: 'HS512'
      )
      
      expect(decoded_key[0]['project_id']).to eq(5)
    end
  end
end
