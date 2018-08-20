describe LocalAuthority::UseCase::CheckApiKey do

  let(:use_case) { described_class.new(api_key_gateway: api_key_gateway_spy) }

  context 'example 1' do
    let(:api_key_gateway_spy) { spy }

    it 'calls the gateway' do
      use_case.execute(api_key: 'cats')
      expect(api_key_gateway_spy).to have_received(:find_by).with(api_key: 'cats')
    end

    context 'the api_key exists' do
      let(:api_key_gateway_spy) { spy(find_by: 0) }

      it 'returns the correct hash' do
        expect(use_case.execute(api_key: 'cats')).to eq({valid: true})
      end
    end

    context 'the api key is non-existent' do
      let(:api_key_gateway_spy) { spy(find_by: nil) }

      it 'returns the correct hash' do
        expect(use_case.execute(api_key: 'ducks')).to eq({valid: false})
      end
    end
  end

  context 'example 2' do
    let(:api_key_gateway_spy) { spy }

    it 'calls the gateway' do
      use_case.execute(api_key: 'dogs')
      expect(api_key_gateway_spy).to have_received(:find_by).with(api_key: 'dogs')
    end

    context 'the api_key exists' do
      let(:api_key_gateway_spy) { spy(find_by: 1) }

      it 'returns the correct hash' do
        expect(use_case.execute(api_key: 'wolf')).to eq({valid: true})
      end
    end

    context 'the api key is non-existent' do
      let(:api_key_gateway_spy) { spy(find_by: nil) }

      it 'returns the correct hash' do
        expect(use_case.execute(api_key: 'cow')).to eq({valid: false})
      end
    end
  end
end
