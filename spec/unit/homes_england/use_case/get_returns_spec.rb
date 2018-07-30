require 'rspec'

describe HomesEngland::UseCase::GetReturns, focus: true do

  let(:all_returns) { [] }
  let(:return_gateway) { spy(get_returns: all_returns)}

  let(:get_returns) {described_class.new(return_gateway: return_gateway)}

  before do
      stub_const(
        'LocalAuthority::Gateway::ReturnGateway',
        double(new: return_gateway)
      )
  end

  context 'with a single item' do
    let(:all_returns) {[
      {
        project_id: 1,
        data:
        {
          summary: {
            project_name: 'Cats Protection League',
            description: 'A new headquarters for all the Cats',
            lead_authority: 'Made Tech'
          },
          infrastructure: {
            type: 'Cat Bathroom',
            description: 'Bathroom for Cats',
            completion_date: '2018-12-25'
          },
          financial: {
            date: '2017-12-25',
            funded_through_HIF: true
          }
        }
      }]}

    it 'sends the correct project_id to return_gateway' do
      get_returns.execute(project_id: 1)
      expect(return_gateway).to have_received(:get_returns).with(project_id: 1)
    end

    it 'can get a single return as an item in an array' do
      expect(get_returns.execute(project_id: 1)).to eq(all_returns)
    end
  end
end
