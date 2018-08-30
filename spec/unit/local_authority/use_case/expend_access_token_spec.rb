# frozen_string_literal: true

describe LocalAuthority::UseCase::ExpendAccessToken do
  let(:access_token_gateway_spy) do
    spy(
      find_by: LocalAuthority::Domain::AccessToken.new.tap do |token|
        token.uuid = 0
        token.project_id = 0
      end
    )
  end
  let(:create_api_key_spy) { spy(execute: { api_key: 'Doggos' }) }

  let(:use_case) do
    described_class.new(access_token_gateway: access_token_gateway_spy,
                        create_api_key: create_api_key_spy)
  end

  context 'given existing Access Tokens' do
    it 'should run the create api use case' do
      access_token = '65d60eb7-18c8-4e32-abf0-1288eb8acc63'
      use_case.execute(access_token: access_token, project_id: 0)
      expect(create_api_key_spy).to have_received(:execute).with(project_id: 0)
    end

    context 'example one' do
      it 'searches for the Access Token' do
        access_token = '65d60eb7-18c8-4e32-abf0-1288eb8acc63'
        use_case.execute(access_token: access_token, project_id: 0)
        expect(access_token_gateway_spy).to have_received(:find_by).with(access_token: access_token)
      end

      it 'removes the Access Token' do
        access_token = '65d60eb7-18c8-4e32-abf0-1288eb8acc63'
        use_case.execute(access_token: access_token, project_id: 0)
        expect(access_token_gateway_spy).to have_received(:delete).with(access_token: access_token)
      end

      context 'with a valid access token' do
        it 'return success' do
          access_token = '65d60eb7-18c8-4e32-abf0-1288eb8acc63'
          expect(use_case.execute(access_token: access_token, project_id: 0)).to eq(status: :success, api_key: 'Doggos')
        end
      end

      context 'when the token is invalid' do
        let(:access_token_gateway_spy) { spy(find_by: nil) }
        it 'return failure' do
          access_token = '65d60eb7-18c8-4e32-abf0-1288eb8acc63'
          expect(use_case.execute(access_token: access_token, project_id: 0)).to eq(status: :failure, api_key: '')
        end
      end
    end

    context 'example two' do
      it 'searches for the Access Token' do
        access_token = 'a4156994-c490-4653-96cd-bf063acec758'
        use_case.execute(access_token: access_token, project_id: 1)
        expect(access_token_gateway_spy).to have_received(:find_by).with(access_token: access_token)
      end

      it 'removes the Access Token' do
        access_token = 'a4156994-c490-4653-96cd-bf063acec758'
        use_case.execute(access_token: access_token, project_id: 1)
        expect(access_token_gateway_spy).to have_received(:delete).with(access_token: access_token)
      end
    end
  end
end
