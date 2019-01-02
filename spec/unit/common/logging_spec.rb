describe Common::Proxy::Logging do
  describe 'Given a logger with the info method' do
    let(:logger_spy) { spy(:info) }
    let(:response) { proxy.execute(request) }
    let(:proxy) { described_class.new(logger: logger_spy, use_case: use_case_spy) }
    before { response }

    describe 'Empty execute' do
      let(:response) { proxy.execute }
      class ExampleUseCase
        attr_reader :executed

        def initialize
          @executed = false
        end

        def execute
          @executed = true
        end
      end

      let(:use_case_spy) { ExampleUseCase.new }

      it 'Calls the usecase execute method' do
        expect(use_case_spy.executed).to eq(true)
      end
    end

    describe 'Example one' do
      class ExampleUseCaseOne
        attr_reader :executed_with

        def initialize(response)
          @response = response
        end

        def execute(request)
          @executed_with = request
          @response
        end
      end

      let(:use_case_spy) { ExampleUseCaseOne.new({ cats: 'Are the best'}) }
      let(:request) { { cat: 'meow', dog: 'woof' } }

      it 'Calls the usecase execute method' do
        expect(use_case_spy.executed_with).not_to be_nil
      end

      it 'Calls the usecase execute method with the given arguments' do
        expect(use_case_spy.executed_with).to eq(cat: 'meow', dog: 'woof')
      end

      it 'Returns the response from the usecase' do
        expect(response).to eq({cats: 'Are the best'})
      end

      it 'Logs the correct message' do
        expect(logger_spy).to have_received(:info).with(
          {
            message_type: 'before-use-case-called',
            name: 'ExampleUseCaseOne',
            request: { cat: 'meow', dog: 'woof'}
          }.inspect
        )
      end

      it 'Logs the correct message' do
        expect(logger_spy).to have_received(:info).with(
          {
            message_type: 'after-use-case-called',
            name: 'ExampleUseCaseOne',
            request: { cat: 'meow', dog: 'woof'},
            response: { cats: 'Are the best' }
          }.inspect
        )
      end
    end

    describe 'Example two' do
      class ExampleUseCaseTwo
        attr_reader :executed_with

        def initialize(response)
          @response = response
        end

        def execute(request)
          @executed_with = request
          @response
        end
      end

      let(:use_case_spy) { ExampleUseCaseTwo.new({ dogs: 'Are also the best'}) }
      let(:request) { { cow: 'moo', chicken: 'cluck' } }

      it 'Calls the usecase execute method' do
        expect(use_case_spy.executed_with).not_to be_nil
      end

      it 'Calls the usecase execute method with the given arguments' do
        expect(use_case_spy.executed_with).to eq(cow: 'moo', chicken: 'cluck')
      end

      it 'Returns the response from the usecase' do
        expect(response).to eq({dogs: 'Are also the best'})
      end

      it 'Logs the correct before message' do
        expect(logger_spy).to have_received(:info).with(
          {
            message_type: 'before-use-case-called',
            name: 'ExampleUseCaseTwo',
            request: { cow: 'moo', chicken: 'cluck' }
          }.inspect
        )
      end

      it 'Logs the correct after message' do
        expect(logger_spy).to have_received(:info).with(
          {
            message_type: 'after-use-case-called',
            name: 'ExampleUseCaseTwo',
            request: { cow: 'moo', chicken: 'cluck' },
            response: { dogs: 'Are also the best'}
          }.inspect
        )
      end
    end
  end

  describe 'Given a nil logger' do
    let(:use_case_spy) { spy(execute: {dog: 'woof'}) }
    let(:proxy) { described_class.new(logger: nil, use_case: use_case_spy)}

    it 'Does not raise an error' do
      expect { proxy.execute({cat: 'meow'}) }.not_to raise_error
    end

    it 'Calls the usecase' do
      proxy.execute(cat: 'meow')

      expect(use_case_spy).to have_received(:execute).with({cat: 'meow'})
    end

    it 'Returns the response from the usecase' do
      response = proxy.execute(cat: 'meow')

      expect(response).to eq(dog: 'woof')
    end
  end
end
