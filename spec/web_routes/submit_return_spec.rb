require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Submitting a return' do
  let(:notification_gateway_spy) { spy }
  let(:get_project_users_spy) { spy }
  let(:send_return_submission_notification_spy) { spy }
  let(:submit_return_spy) { spy(execute: nil) }

  before do
    stub_const(
      'LocalAuthority::Gateway::GovEmailNotificationGateway',
      double(new: notification_gateway_spy)
    )

    stub_const(
      'LocalAuthority::Gateway::GetProjectUsers',
      double(new: get_project_users_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::SubmitReturn',
      double(new: submit_return_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::SendReturnSubmissionNotification',
      double(new: send_return_submission_notification_spy)
    )
  end

  it 'submitting nothing should return 400' do
    post '/return/submit', nil
    expect(last_response.status).to eq(400)
  end

  it 'submitting a valid id should return 200' do
    post '/return/submit', { return_id: 1 }.to_json
    expect(last_response.status).to eq(200)
  end

  context 'example one' do
    it 'will run submit return use case with id' do
      post '/return/submit', { return_id: 1, project_id: 1 }.to_json
      expect(submit_return_spy).to have_received(:execute).with(return_id: 1)
    end

    it 'will run notify project members use case with id' do
      post '/return/submit', { return_id: 1, project_id: 1 }.to_json
      expect(send_return_submission_notification_spy).to have_received(:execute).with(project_id: 1)
    end
  end


  context 'example two' do
    it 'will run submit return use case with id' do
      post '/return/submit', { return_id: 42, project_id: 1 }.to_json
      expect(submit_return_spy).to have_received(:execute).with(return_id: 42)
    end

    it 'will run notify project members use case with id' do
      post '/return/submit', { return_id: 1, project_id: 443 }.to_json
      expect(send_return_submission_notification_spy).to have_received(:execute).with(project_id: 443)
    end
  end

end
