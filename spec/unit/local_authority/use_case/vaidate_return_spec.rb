# frozen_string_literal: true

describe LocalAuthority::UseCase::ValidateReturn do
  let (:project_type) { 'hif' }
  let (:template) do
    LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
      p.schema = {}
    end
  end

  let(:return_template_gateway_spy) { double(find_by: template) }
  let(:use_case) do
    described_class.new(return_template_gateway: return_template_gateway_spy)
  end

  it 'should have accept project type and return data' do
    use_case.execute(type: project_type, return_data: {})
  end

  context 'required field validation' do
    context 'given a single field' do
      context 'example one' do
        let (:template) do
          LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['percentComplete'],
              properties: {
                percentComplete: {
                  type: 'integer',
                  title: 'Percent complete'
                }
              }
            }
          end
        end

        it 'should call return template gateway with type' do
          use_case.execute(type: project_type, return_data: {})
          expect(return_template_gateway_spy).to have_received(:find_by).with(type: project_type)
        end

        context 'given valid return' do
          let(:valid_return_data) do
            {
              percentComplete: 99
            }
          end
          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: valid_return_data)
            expect(return_value[:valid]).to eq(true)
          end
        end

        context 'given an invalid return' do
          let(:invalid_return_data) do
            {
              percentComplete: nil
            }
          end
          it 'should return a hash with a valid field as false' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:valid]).to eq(false)
          end
        end
      end

      context 'example two' do
        let (:template) do
          LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['catsComplete'],
              properties: {
                catsComplete: {
                  type: 'string',
                  title: 'cats compete on the beach to complete the complex beat'
                }
              }
            }
          end
        end

        let (:project_type) { 'cats' }
        it 'should call return template gateway with type' do
          use_case.execute(type: project_type, return_data: {})
          expect(return_template_gateway_spy).to have_received(:find_by).with(type: project_type)
        end

        context 'given valid return' do
          let(:valid_return_data) do
            {
              catsComplete: 'The Cat Plan'
            }
          end
          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: valid_return_data)
            expect(return_value[:valid]).to eq(true)
          end
        end

        context 'given an invalid return' do
          let(:valid_return_data) do
            {
              catsComplete: nil
            }
          end
          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: valid_return_data)
            expect(return_value[:valid]).to eq(false)
          end
        end
      end
    end

    context 'given a nested field' do
      context 'example one' do
        let (:template) do
          LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                planning: {
                  type: 'object',
                  title: 'Planning',
                  required: ['percentComplete'],
                  properties: {
                    percentComplete: {
                      type: 'integer',
                      title: 'Percent complete'
                    }
                  }
                }
              }
            }
          end
        end

        it 'should call return template gateway with type' do
          use_case.execute(type: project_type, return_data: {})
          expect(return_template_gateway_spy).to have_received(:find_by).with(type: project_type)
        end

        context 'given valid return' do
          let(:valid_return_data) do
            {
              planning: {
                percentComplete: 99
              }
            }
          end

          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: valid_return_data)
            expect(return_value[:valid]).to eq(true)
          end
        end

        context 'given an invalid return' do
          let(:invalid_return_data) do
            {
              planning: {
                percentComplete: nil
              }
            }
          end
          it 'should return a hash with a valid field as false' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:valid]).to eq(false)
          end
        end
      end

      context 'example two' do
        let (:template) do
          LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                planning: {
                  type: 'object',
                  title: 'Planning',
                  required: ['catsComplete'],
                  properties: {
                    catsComplete: {
                      type: 'string',
                      title: 'cats compete on the beach to complete the complex beat'
                    }
                  }
                }
              }
            }
          end
        end

        let (:project_type) { 'cats' }
        it 'should call return template gateway with type' do
          use_case.execute(type: project_type, return_data: {})
          expect(return_template_gateway_spy).to have_received(:find_by).with(type: project_type)
        end

        context 'given valid return' do
          let(:valid_return_data) do
            {
              planning: {
                catsComplete: 'The Cat Plan'
              }
            }
          end
          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: valid_return_data)
            expect(return_value[:valid]).to eq(true)
          end
        end

        context 'given an invalid return' do
          let(:valid_return_data) do
            {
              planning: {
                catsComplete: nil
              }
            }
          end
          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: valid_return_data)
            expect(return_value[:valid]).to eq(false)
          end
        end
      end
    end

    context 'given a nested field with multiple entries' do
      context 'example one' do
        let (:template) do
          LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['cats'],
              properties: {
                planning: {
                  type: 'object',
                  title: 'Planning',
                  required: ['percentComplete'],
                  properties: {
                    percentComplete: {
                      type: 'integer',
                      title: 'Percent complete'
                    },
                    notComplete: {
                      type: 'string',
                      title: 'Not Complete'
                    }
                  }
                },
                cats: {
                  type: 'string',
                  title: 'Wearing hats'
                }
              }
            }
          end
        end

        it 'should call return template gateway with type' do
          use_case.execute(type: project_type, return_data: {})
          expect(return_template_gateway_spy).to have_received(:find_by).with(type: project_type)
        end

        context 'given valid return' do
          let(:valid_return_data) do
            {
              planning: {
                percentComplete: 99
              },
              cats: 'Love the hats'
            }
          end

          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: valid_return_data)
            expect(return_value[:valid]).to eq(true)
          end
        end

        context 'given an invalid return' do
          let(:invalid_return_data) do
            {
              planning: {
                percentComplete: nil,
                notComplete: 'Cows'
              },
              cats: nil
            }
          end
          it 'should return a hash with a valid field as false' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:valid]).to eq(false)
          end
        end

        context 'given partially invalid return' do
          let(:invalid_return_data) do
            {
              planning: {
                percentComplete: nil,
                notComplete: 'Cows'
              },
              cats: 'To Be Valid'
            }
          end
          it 'should return a hash with a valid field as false' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:valid]).to eq(false)
          end
        end
      end

      context 'example two' do
        let (:template) do
          LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['dogs'],
              properties: {
                planning: {
                  type: 'object',
                  title: 'Planning',
                  required: ['catsComplete'],
                  properties: {
                    catsComplete: {
                      type: 'string',
                      title: 'cats compete on the beach to complete the complex beat'
                    },
                    theAnswer: {
                      type: 'integer',
                      title: 'What is the answer to life, the universe and everything?'
                    }
                  }
                },
                dogs: {
                  title: 'Dogs R Us',
                  type: 'string'
                }
              }
            }
          end
        end

        let (:project_type) { 'cats' }
        it 'should call return template gateway with type' do
          use_case.execute(type: project_type, return_data: {})
          expect(return_template_gateway_spy).to have_received(:find_by).with(type: project_type)
        end

        context 'given valid return' do
          let(:valid_return_data) do
            {
              planning: {
                catsComplete: 'The Cat Plan'
              },
              dogs: 'Scout, The Dog, was here'
            }
          end
          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: valid_return_data)
            expect(return_value[:valid]).to eq(true)
          end
        end

        context 'given an invalid return' do
          let(:valid_return_data) do
            {
              planning: {
                catsComplete: '',
                theAnswer: 43
              }
            }
          end
          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: valid_return_data)
            expect(return_value[:valid]).to eq(false)
          end
        end
      end
    end
  end
end
