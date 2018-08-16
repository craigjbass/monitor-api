describe LocalAuthority::UseCase::CreateApiKey do
  let(:api_key_gateway_spy) { spy }
  let(:use_case) { described_class.new(api_key_gateway: api_key_gateway_spy).execute }

  context 'calls the api_key gateway' do
    it 'is a valid API key' do
      use_case
      expect(api_key_gateway_spy).to have_received(:save) do |arg|
        expect(arg[:api_key].length).to eq(36)
        expect(arg[:api_key].class).to eq(String)
      end
    end

    it 'does not generate the same key twice' do
      expect(described_class.new(api_key_gateway: api_key_gateway_spy).execute).to_not eq(
         described_class.new(api_key_gateway: api_key_gateway_spy).execute
       )
    end
  end
end
