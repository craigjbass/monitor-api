# frozen_string_literal: true

require 'rspec'

describe HomesEngland::UseCase::ExportProjectData do
  let(:returns) { {returns: []} }
  let(:project) { {} }

  let(:get_returns_spy) { spy(execute: returns) }
  let(:find_project_spy) { spy(execute: project) }

  context 'calls the FindProject usecase' do
    example 'example 1' do
      described_class.new(find_project: find_project_spy, get_returns: get_returns_spy).execute(project_id: 0)
      expect(find_project_spy).to have_received(:execute).with(id: 0)
    end

    example 'example 2' do
      described_class.new(find_project: find_project_spy, get_returns: get_returns_spy).execute(project_id: 66)
      expect(find_project_spy).to have_received(:execute).with(id: 66)
    end
  end

  context 'calls the GetReturn usecase' do
    example 'example 1' do
      described_class.new(find_project: find_project_spy, get_returns: get_returns_spy).execute(project_id: 0)
      expect(get_returns_spy).to have_received(:execute).with(project_id: 0)
    end

    example 'example 2' do
      described_class.new(find_project: find_project_spy, get_returns: get_returns_spy).execute(project_id: 66)
      expect(get_returns_spy).to have_received(:execute).with(project_id: 66)
    end
  end

  context 'produces an accurate compiled project' do
    context 'example 1' do
      let(:returns) do
        {
          returns: [
            {
              id: 0,
              project_id: 0,
              status: 'Submitted',
              updates: [
                {
                  dogs: 'woof'
                }
              ]
            }
          ]
        }
      end
      let(:project) do
        {
          name: 'Meow project',
          type: 'hif',
          data: {
            cats: 'meow'
          },
          status: 'Submitted'
        }
      end

      let(:expected_compiled_project) do
        {
          baseline: {
            name: 'Meow project',
            project_id: 0,
            type: 'hif',
            data: {
              cats: 'meow'
            }
          },
          submitted_returns: [
            {
              id: 0,
              project_id: 0,
              data: {
                dogs: 'woof'
              }
            }
          ]
        }
      end

      it 'example' do
        compiled_project = described_class.new(find_project: find_project_spy, get_returns: get_returns_spy).execute(project_id: 0)[:compiled_project]
        expect(compiled_project).to eq(expected_compiled_project)
      end
    end

    context 'example 2' do
      let(:returns) do
        {
          returns: [
            {
              id: 66,
              project_id: 6,
              status: 'Submitted',
              updates: [
                {
                  cow: 'moo'
                }
              ]
            }
          ]
        }
      end
      let(:project) do
        {
          name: 'Mouse project',
          type: 'hif',
          data: {
            mouse: 'squeak'
          },
          status: 'Submitted'
        }
      end

      let(:expected_compiled_project) do
        {
          baseline: {
            name: 'Mouse project',
            project_id: 6,
            type: 'hif',
            data: {
              mouse: 'squeak'
            }
          },
          submitted_returns: [
            {
              id: 66,
              project_id: 6,
              data: {
                cow: 'moo'
              }
            }
          ]
        }
      end

      it 'example' do
        compiled_project = described_class.new(find_project: find_project_spy, get_returns: get_returns_spy).execute(project_id: 6)[:compiled_project]
        expect(compiled_project).to eq(expected_compiled_project)
      end
    end
  end

  context 'produces an accurate compiled project with multiple returns' do
    context 'example 1' do
      let(:returns) do
        {
          returns: [
            {
              id: 66,
              project_id: 6,
              status: 'Submitted',
              updates: [
                {
                  cow: 'moo'
                }
              ]
            },
            {
              id: 67,
              project_id: 6,
              status: 'Submitted',
              updates: [
                {
                  duck: 'quack'
                }
              ]
            }
          ]
        }
      end

      let(:project) do
        {
          name: 'squeak project',
          type: 'hif',
          data: {
            mouse: 'squeak'
          },
          status: 'Submitted'
        }
      end

      let(:expected_compiled_project) do
        {
          baseline: {
            name: 'squeak project',
            project_id: 6,
            type: 'hif',
            data: {
              mouse: 'squeak'
            }
          },
          submitted_returns: [
            {
              id: 66,
              project_id: 6,
              data: {
                cow: 'moo'
              }
            },
            {
              id: 67,
              project_id: 6,
              data: {
                duck: 'quack'
              }
            }
          ]
        }
      end

      it 'example' do
        compiled_project = described_class.new(find_project: find_project_spy, get_returns: get_returns_spy).execute(project_id: 6)[:compiled_project]
        expect(compiled_project).to eq(expected_compiled_project)
      end
    end

    context 'example 2' do
      let(:returns) do
        {
          returns: [
          {
            id: 67,
            project_id: 8,
            status: 'Submitted',
            updates: [
              {
                duck: 'quack'
              }
            ]
          },
            {
              id: 86,
              project_id: 8,
              status: 'Submitted',
              updates: [
                {
                  wolf: 'awoo'
                }
              ]
            }
          ]
        }
      end

      let(:project) do
        {
          name: 'squeak project',
          type: 'hif',
          data: {
            mouse: 'squeak'
          },
          status: 'Submitted'
        }
      end

      let(:expected_compiled_project) do
        {
          baseline: {
            name: 'squeak project',
            project_id: 8,
            type: 'hif',
            data: {
              mouse: 'squeak'
            }
          },
          submitted_returns: [
            {
              id: 67,
              project_id: 8,
              data: {
                duck: 'quack'
              }
            },
            {
              id: 86,
              project_id: 8,
              data: {
                wolf: 'awoo'
              }
            },
          ]
        }
      end

      it 'example' do
        compiled_project = described_class.new(find_project: find_project_spy, get_returns: get_returns_spy).execute(project_id: 8)[:compiled_project]
        expect(compiled_project).to eq(expected_compiled_project)
      end
    end
  end

  context 'produces an accurate compiled project with multiple returns with multiple updates' do
    context 'example 1' do
      let(:returns) do
        {
          returns: [
            {
              id: 66,
              project_id: 6,
              status: 'Submitted',
              updates: [
                {
                  cow: 'moo'
                }
              ]
            },
            {
              id: 67,
              project_id: 6,
              status: 'Submitted',
              updates: [
                {
                  dog: 'woof'
                },
                {
                  cat: 'meow'
                },
                {
                  duck: 'quack'
                }
              ]
            }
          ]
        }
      end

      let(:project) do
        {
          name: 'squeak project',
          type: 'hif',
          data: {
            mouse: 'squeak'
          },
          status: 'Submitted'
        }
      end

      let(:expected_compiled_project) do
        {
          baseline: {
            name: 'squeak project',
            project_id: 6,
            type: 'hif',
            data: {
              mouse: 'squeak'
            }
          },
          submitted_returns: [
            {
              id: 66,
              project_id: 6,
              data: {
                cow: 'moo'
              }
            },
            {
              id: 67,
              project_id: 6,
              data: {
                duck: 'quack'
              }
            }
          ]
        }
      end

      it 'example' do
        compiled_project = described_class.new(find_project: find_project_spy, get_returns: get_returns_spy).execute(project_id: 6)[:compiled_project]
        expect(compiled_project).to eq(expected_compiled_project)
      end
    end

    context 'example 2' do
      let(:returns) do
        {
          returns: [
          {
            id: 67,
            project_id: 8,
            status: 'Submitted',
            updates: [
              {
                raven: 'squark'
              },
              {
                duck: 'quack'
              }
            ]
          },
            {
              id: 86,
              project_id: 8,
              status: 'Submitted',
              updates: [
                {
                  wolf: 'awoo'
                }
              ]
            }
          ]
        }
      end

      let(:project) do
        {
          name: 'squeak project',
          type: 'hif',
          data: {
            mouse: 'squeak'
          },
          status: 'Submitted'
        }
      end

      let(:expected_compiled_project) do
        {
          baseline: {
            name: 'squeak project',
            project_id: 8,
            type: 'hif',
            data: {
              mouse: 'squeak'
            }
          },
          submitted_returns: [
            {
              id: 67,
              project_id: 8,
              data: {
                duck: 'quack'
              }
            },
            {
              id: 86,
              project_id: 8,
              data: {
                wolf: 'awoo'
              }
            },
          ]
        }
      end

      it 'example' do
        compiled_project = described_class.new(find_project: find_project_spy, get_returns: get_returns_spy).execute(project_id: 8)[:compiled_project]
        expect(compiled_project).to eq(expected_compiled_project)
      end
    end
  end

  context 'produces an accurate compiled project with multiple return that excludes draft returns' do
    context 'example 1' do
      let(:returns) do
        {
          returns: [
            {
              id: 66,
              project_id: 6,
              status: 'Draft',
              updates: [
                {
                  cow: 'moo'
                }
              ]
            },
            {
              id: 67,
              project_id: 6,
              status: 'Submitted',
              updates: [
                {
                  duck: 'quack'
                }
              ]
            }
          ]
        }
      end

      let(:project) do
        {
          name: 'squeak project',
          type: 'hif',
          data: {
            mouse: 'squeak'
          },
          status: 'Submitted'
        }
      end

      let(:expected_compiled_project) do
        {
          baseline: {
            name: 'squeak project',
            project_id: 6,
            type: 'hif',
            data: {
              mouse: 'squeak'
            }
          },
          submitted_returns: [
            {
              id: 67,
              project_id: 6,
              data: {
                duck: 'quack'
              }
            }
          ]
        }
      end

      it 'example' do
        compiled_project = described_class.new(find_project: find_project_spy, get_returns: get_returns_spy).execute(project_id: 6)[:compiled_project]
        expect(compiled_project).to eq(expected_compiled_project)
      end
    end

    context 'example 2' do
      let(:returns) do
        {
          returns: [
            {
              id: 61,
              project_id: 8,
              status: 'Submitted',
              updates: [
                {
                  raven: 'squark'
                }
              ]
            },
            {
              id: 86,
              project_id: 8,
              status: 'Draft',
              updates: [
                {
                  wolf: 'awoo'
                }
              ]
            },
            {
              id: 89,
              project_id: 8,
              status: 'Draft',
              updates: [
                {
                  wolf: 'awoo'
                }
              ]
            }
          ]
        }
      end

      let(:project) do
        {
          name: 'squeak project',
          type: 'hif',
          data: {
            mouse: 'squeak'
          },
          status: 'Submitted'
        }
      end

      let(:expected_compiled_project) do
        {
          baseline: {
            name: 'squeak project',
            project_id: 8,
            type: 'hif',
            data: {
              mouse: 'squeak'
            }
          },
          submitted_returns: [
            {
              id: 61,
              project_id: 8,
              data: {
                raven: 'squark'
              }
            }
          ]
        }
      end

      it 'example' do
        compiled_project = described_class.new(find_project: find_project_spy, get_returns: get_returns_spy).execute(project_id: 8)[:compiled_project]
        expect(compiled_project).to eq(expected_compiled_project)
      end
    end
  end
end
