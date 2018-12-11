# frozen_string_literal: true

require 'rspec'

describe HomesEngland::UseCase::ExportAllProjects do
  let(:export_project_spy) do
    spy(execute: {
      compiled_project: {
          baseline: {
            cathouse: "Cats"
          },
          submitted_returns: [
            {
              cats: "Meow"
            }
          ]
        }
      }
    )
  end

  let(:project_gateway_spy) do
    spy(all:
      [
        HomesEngland::Domain::Project.new.tap do |p|
          p.id = 0
          p.name = 'Cat project'
          p.type = 'Animals'
          p.status = 'Draft'
          p.data = { cats: 'meow' }
        end
      ]
    )
  end

  let(:use_case) { described_class.new(project_gateway: project_gateway_spy, export_project: export_project_spy) }
  it 'calls the project gateway' do
    use_case.execute
    expect(project_gateway_spy).to have_received(:all)
  end

  context 'getting the project data' do
    context 'example 1' do
      let(:project_gateway_spy) do
        spy(all:
          [
            HomesEngland::Domain::Project.new.tap do |p|
              p.id = 0
              p.name = 'Cat project'
              p.type = 'Animals'
              p.status = 'Submitted'
              p.data = { cats: 'meow' }
            end
          ]
        )
      end

      let(:export_project_spy) do
        spy(execute: {
          compiled_project: {
              baseline: {
                cats: 'meow'
              },
              submitted_returns: [
                {
                  data: 'other data'
                }
              ]
            }
          }
        )
      end

      it 'calls the use case' do
        use_case.execute
        expect(export_project_spy).to have_received(:execute).with(project_id: 0)
      end

      it 'returns the exported data' do
        expect(use_case.execute).to eq({
          compiled_projects: [
              {
                baseline: {
                  cats: 'meow'
                },
                submitted_returns: [
                  {
                    data: 'other data'
                  }
                ]
              }
            ]
          }
        )
      end
     end

    context 'example 2' do
      let(:project_gateway_spy) do
        spy(all:
          [
            HomesEngland::Domain::Project.new.tap do |p|
              p.id = 65536
              p.name = 'Cat project'
              p.type = 'Animals'
              p.status = 'Submitted'
              p.data = { cats: 'meow' }
            end,
            HomesEngland::Domain::Project.new.tap do |p|
              p.id = 255
              p.name = 'Cat project'
              p.type = 'Animals'
              p.status = 'Submitted'
              p.data = { cats: 'meow' }
            end
          ]
        )
      end

      let(:export_project_spy) do
        spy(execute: {
          compiled_project: {
              baseline: {
                cats: 'meow'
              },
              submitted_returns: [
                {
                  data: 'other data'
                }
              ]
            }
          }
        )
      end

      it 'calls the use case' do
        use_case.execute
        expect(export_project_spy).to have_received(:execute).with(project_id: 65536)
        expect(export_project_spy).to have_received(:execute).with(project_id: 255)
      end

      context 'multiple projects' do
        let(:export_project_spy) do
          Class.new do
            def initialize
              @compiled_projects = [
                {
                  compiled_project: {
                    baseline: {
                      dogs: 'meow'
                    },
                    submitted_returns: [
                      {
                        data: 'other data'
                      }
                    ]
                  }
                },
                {
                  compiled_project: {
                    baseline: {
                      dogs: 'woof'
                    },
                    submitted_returns: [
                      {
                        data: 'other data'
                      }
                    ]
                  }
                }
              ]
            end

            def execute(project_id:)
              @compiled_projects.shift
            end
          end.new
        end

        it 'returns the exported data' do
          expect(use_case.execute).to eq({
            compiled_projects: [
                {
                  baseline: {
                    dogs: 'meow'
                  },
                  submitted_returns: [
                    {
                      data: 'other data'
                    }
                  ]
                },
                {
                  baseline: {
                    dogs: 'woof'
                  },
                  submitted_returns: [
                    {
                      data: 'other data'
                    }
                  ]
                }
              ]
            }
          )
        end
      end
    end
  end
end
