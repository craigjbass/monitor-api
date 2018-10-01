require 'date'
require 'timecop'

describe LocalAuthority::UseCase::CreateApiKey do
  let(:use_case) { described_class.new }
  let(:four_hours_in_seconds) { 60 * 60 * 4 }

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

    it 'Sets the expiry to 4 hours away' do
      now = DateTime.now + 1
      Timecop.freeze(now)
      api_key = use_case.execute(project_id: 1)[:api_key]
      Timecop.return


      decoded_key = JWT.decode(
        api_key,
        'cats',
        true,
        algorithm: 'HS512'
      )

      expected_time = now.strftime("%s").to_i + four_hours_in_seconds

      expect(decoded_key[0]['exp']).to eq(expected_time)
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

    it 'Sets the expiry to 4 hours away' do
      now = DateTime.now + 5
      Timecop.freeze(now)
      api_key = use_case.execute(project_id: 1)[:api_key]
      Timecop.return


      decoded_key = JWT.decode(
        api_key,
        'dogs',
        true,
        algorithm: 'HS512'
      )

      expected_time = now.strftime("%s").to_i + four_hours_in_seconds

      expect(decoded_key[0]['exp']).to eq(expected_time)
    end
  end
end
