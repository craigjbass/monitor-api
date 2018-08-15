# frozen_string_literal: true

describe LocalAuthority::UseCase::ExpendGUID do
  let(:guid_gateway_spy) { spy(find_by: 0) }

  let(:use_case) { described_class.new(guid_gateway: guid_gateway_spy) }


  context 'given existing GUIDs' do
    context 'example one' do
      it 'searches for the GUID' do
        guid = '65d60eb7-18c8-4e32-abf0-1288eb8acc63'
        use_case.execute(guid: guid)
        expect(guid_gateway_spy).to have_received(:find_by).with(guid: guid)
      end

      it 'removes the GUID' do
        guid = '65d60eb7-18c8-4e32-abf0-1288eb8acc63'
        use_case.execute(guid: guid)
        expect(guid_gateway_spy).to have_received(:delete).with(guid: guid)
      end

      context 'when find_by is 0' do
        it 'returns success for an existing GUID' do
          guid = '65d60eb7-18c8-4e32-abf0-1288eb8acc63'
          expect(use_case.execute(guid: guid)).to eq(status: :success)
        end
        it 'returns success' do
          guid = '65d60eb7-18c8-4e32-abf0-1288eb8acc63'
          expect(use_case.execute(guid: guid)).to eq(status: :success)
        end
      end

      context 'when find_by is nil' do
        let(:guid_gateway_spy) { spy(find_by: nil) }
        it 'returns success for an existing GUID' do
          guid = '65d60eb7-18c8-4e32-abf0-1288eb8acc63'
          expect(use_case.execute(guid: guid)).to eq(status: :failure)
        end
        it 'returns success' do
          guid = '65d60eb7-18c8-4e32-abf0-1288eb8acc63'
          expect(use_case.execute(guid: guid)).to eq(status: :failure)
        end
      end
    end

    context 'example two' do
      it 'searches for the GUID' do
        guid = 'a4156994-c490-4653-96cd-bf063acec758'
        use_case.execute(guid: guid)
        expect(guid_gateway_spy).to have_received(:find_by).with(guid: guid)
      end

      it 'removes the GUID' do
        guid = 'a4156994-c490-4653-96cd-bf063acec758'
        use_case.execute(guid: guid)
        expect(guid_gateway_spy).to have_received(:delete).with(guid: guid)
      end
    end
  end
end
