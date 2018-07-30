require 'rspec'

describe HomesEngland::UseCase::GetReturns do
  let(:all_returns) { [] }
  let(:all_return_objects) { [] }
  let(:return_gateway) { spy(get_returns: all_return_objects) }

  let(:get_returns) { described_class.new(return_gateway: return_gateway) }

  context 'with a single item' do
    let(:all_returns) do
      [
        {
          id: 1,
          project_id: 1,
          data: { dogs: 'woof' }
        }
      ]
    end

    let(:all_return_objects) do
      [
        LocalAuthority::Domain::Return.new.tap do |r|
          r.id = 1
          r.project_id = 1
          r.data = { dogs: 'woof' }
        end
      ]
    end

    it 'sends the correct project_id to return_gateway' do
      get_returns.execute(project_id: 1)
      expect(return_gateway).to have_received(:get_returns).with(project_id: 1)
    end

    it 'can get a single return as an item in an array' do
      expect(get_returns.execute(project_id: 1)).to match_array(all_returns)
    end
  end

  context 'with multiple returns in the same project' do
    let(:all_returns) do
      [
        {
          id: 1,
          project_id: 1,
          data: { cats: 'meow' }
        },
        {
          id: 2,
          project_id: 1,
          data: { dogs: 'woof' }
        }
      ]
    end

    let(:all_return_objects) do
      [
        LocalAuthority::Domain::Return.new.tap do |r|
          r.id = 1
          r.project_id = 1
          r.data = { cats: 'meow' }
        end,
        LocalAuthority::Domain::Return.new.tap do |r|
          r.id = 2
          r.project_id = 1
          r.data = { dogs: 'woof' }
        end
      ]
    end

    it 'can get multiple items as an array' do
      expect(get_returns.execute(project_id: 1)).to match_array(all_returns)
    end
  end
end
