describe LocalAuthority::UseCase::NotifyProjectMembers do
  let(:send_return_submission_notification_spy) { spy }
  let(:emails) { [] }
  let(:get_project_users_spy) { spy(execute: { users: emails }) }

  let(:use_case) do
    described_class.new(
      send_return_submission_notification: send_return_submission_notification_spy,
      get_project_users: get_project_users_spy
    )
  end

  context 'single user' do
    context 'example 1' do
      let(:emails) do
        ['cat@cathouse.com']
      end

      it 'executes the send return submission notification use case' do
        use_case.execute(project_id: 1, url: 'meow')
        expect(send_return_submission_notification_spy).to have_received(:execute)
          .with(email: 'cat@cathouse.com', url: 'meow')
      end

      it 'executes the project users use case' do
        use_case.execute(project_id: 1, url: 'meow')
        expect(get_project_users_spy).to have_received(:execute)
          .with(project_id: 1)
      end
    end

    context 'example 2' do
      let(:emails) do
        ['dog@doghouse.com']
      end

      it 'executes the send return submission notification use case' do
        use_case.execute(project_id: 1, url: 'woof')
        expect(send_return_submission_notification_spy).to have_received(:execute)
          .with(email: 'dog@doghouse.com', url: 'woof')
      end

      it 'executes the project users use case' do
        use_case.execute(project_id: 255, url: 'woof')
        expect(get_project_users_spy).to have_received(:execute)
          .with(project_id: 255)
      end
    end
  end

  context 'multiuser' do
    context 'example 1' do
      let(:emails) do
        ['cat@cathouse.com', 'cow@cowhouse.com']
      end

      it 'executes the send return submission notification use case' do
        use_case.execute(project_id: 1, url: 'meow')
        expect(send_return_submission_notification_spy).to have_received(:execute)
          .with(email: 'cat@cathouse.com', url: 'meow')
        expect(send_return_submission_notification_spy).to have_received(:execute)
          .with(email: 'cow@cowhouse.com', url: 'meow')
      end

      it 'executes the project users use case' do
        use_case.execute(project_id: 1, url: 'meow')
        expect(get_project_users_spy).to have_received(:execute)
          .with(project_id: 1)
      end
    end

    context 'example 2' do
      let(:emails) do
        ['mole@hole.com', 'kanga@roo.net', 'dog@doghouse.com']
      end

      it 'executes the send return submission notification use case' do
        use_case.execute(project_id: 1, url: 'woof')
        expect(send_return_submission_notification_spy).to have_received(:execute)
          .with(email: 'mole@hole.com', url: 'woof')
        expect(send_return_submission_notification_spy).to have_received(:execute)
          .with(email: 'kanga@roo.net', url: 'woof')
        expect(send_return_submission_notification_spy).to have_received(:execute)
          .with(email: 'dog@doghouse.com', url: 'woof')
      end
    end
  end
end
