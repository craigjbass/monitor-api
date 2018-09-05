# frozen_string_literal: true

describe LocalAuthority::UseCase::ValidateReturn do
  let(:project_type) { 'hif' }
  let(:template) do
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
        let(:template) do
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

          it 'should have no paths' do
            return_value = use_case.execute(type: project_type, return_data: valid_return_data)
            expect(return_value[:invalid_paths]).to eq([])
          end
        end

        context 'given an invalid return' do
          let(:invalid_return_data) do
            {

            }
          end
          it 'should return a hash with a valid field as false' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:valid]).to eq(false)
          end

          it 'should return the correct path' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:invalid_paths]).to eq([[:percentComplete]])
          end
        end
      end

      context 'example two' do
        let(:template) do
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

        let(:project_type) { 'cats' }
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
          let(:invalid_return_data) do
            {

            }
          end
          it 'should return a hash with a invalid field as true' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:valid]).to eq(false)
          end

          it 'should return the correct path' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:invalid_paths]).to eq([[:catsComplete]])
          end
        end
      end
    end

    context 'given a nested field' do
      context 'example one' do
        let(:template) do
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
        let(:template) do
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

        let(:project_type) { 'cats' }
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
              planning: {}
            }
          end
          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: valid_return_data)
            expect(return_value[:valid]).to eq(false)
          end
        end
      end
    end

    context 'given a nested field with an array' do
      context 'example one' do
        let(:template) do
          LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['cats'],
              properties: {
                planning: {
                  type: 'object',
                  title: 'Planning',
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
                  type: 'array',
                  title: 'Wearing hats',
                  minItems: 1,
                  items: {
                    type: 'object',
                    title: 'Cats',
                    properties: {
                      name: {
                        type: 'string',
                        title: 'Cat Name'
                      }
                    }
                  }
                }
              }
            }
          end
        end

        context 'given a invalid return without the cats property' do
          let(:invalid_return_data) { {} }

          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:valid]).to eq(false)
          end
        end

        context 'given a invalid return without enough items' do
          let(:invalid_return_data) do
            {
              cats: []
            }
          end

          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:valid]).to eq(false)
          end
        end

        context 'given a valid return' do
          let(:valid_return_data) do
            {
              cats: [{ name: 'Love the hats' }]
            }
          end

          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: valid_return_data)
            expect(return_value[:valid]).to eq(true)
          end
        end
      end

      context 'example two' do
        let(:template) do
          LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: ['dogs'],
              properties: {
                planning: {
                  type: 'object',
                  title: 'Planning',
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
                dogs: {
                  type: 'array',
                  title: 'Wearing caps',
                  minItems: 1,
                  items: {
                    name: {
                      type: 'string',
                      title: 'Dog Name'
                    }
                  }
                }
              }
            }
          end
        end

        context 'given a invalid return without the dogs property' do
          let(:invalid_return_data) { {} }

          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:valid]).to eq(false)
          end
        end

        context 'given a invalid return without enough items' do
          let(:invalid_return_data) do
            {
              dogs: []
            }
          end

          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:valid]).to eq(false)
          end
        end

        context 'given a valid return' do
          let(:valid_return_data) do
            {
              dogs: [{ name: 'Love the hats' }]
            }
          end

          it 'should return a hash with a valid field as true' do
            return_value = use_case.execute(type: project_type, return_data: valid_return_data)
            expect(return_value[:valid]).to eq(true)
          end
        end
      end

      context 'given an array with a nested invalid field' do
        context 'example one' do
          let(:template) do
            LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
              p.schema = {
                title: 'HIF Project',
                type: 'object',
                required: ['dogs'],
                properties: {
                  planning: {
                    type: 'object',
                    title: 'Planning',
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
                  dogs: {
                    type: 'array',
                    title: 'Wearing caps',
                    items: {
                      type: 'object',
                      required: ['name'],
                      properties:
                        {
                          name: {
                            type: 'string',
                            title: 'Dog Name'
                          }
                        }
                    }
                  }
                }
              }
            end
          end

          context 'given an invalid return with no array' do
            let(:invalid_return_data) do
              {
                dogs: [{}]
              }
            end

            it 'should return a hash with a invalid field as true' do
              return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
              expect(return_value[:valid]).to eq(false)
            end
          end

          context 'given an valid return with no array' do
            let(:valid_return_data) do
              {
                dogs: [{ name: 'Scout, The Dog.' }]
              }
            end

            it 'should return a hash with a invalid field as true' do
              return_value = use_case.execute(type: project_type, return_data: valid_return_data)
              expect(return_value[:valid]).to eq(true)
            end
          end
        end

        context 'example two' do
          let(:template) do
            LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
              p.schema = {
                title: 'HIF Project',
                type: 'object',
                required: ['cats'],
                'additionalItems': false,
                properties: {
                  planning: {
                    type: 'object',
                    'additionalItems': false,
                    title: 'Planning',
                    properties: {
                      percentComplete: {
                        'additionalItems': false,
                        type: 'integer',
                        title: 'Percent complete'
                      },
                      notComplete: {
                        'additionalItems': false,
                        type: 'string',
                        title: 'Not Complete'
                      }
                    }
                  },
                  cats: {
                    'additionalItems': false,
                    type: 'array',
                    title: 'Wearing caps',
                    items: {
                      type: 'object',
                      required: ['catName'],
                      properties:
                        {
                          catName: {
                            type: 'string',
                            title: 'Cat Name'
                          }
                        }
                    }
                  }
                }
              }
            end
          end

          context 'given an invalid return with no array' do
            let(:invalid_return_data) do
              {
                cats: [{ catName: 'Hello' }, {}]
              }
            end

            it 'should return a hash with a invalid field as true' do
              return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
              expect(return_value[:valid]).to eq(false)
            end
          end

          context 'given an valid return with no array' do
            let(:valid_return_data) do
              {
                cats: [{ catName: 'Scout, The Cat.' }, { catName: 'Robin, The Cat.' }]
              }
            end

            it 'should return a hash with a invalid field as true' do
              return_value = use_case.execute(type: project_type, return_data: valid_return_data)
              expect(return_value[:valid]).to eq(true)
            end
          end
        end
      end
    end

    context 'given a nested field with multiple entries' do
      context 'example one' do
        let(:template) do
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
                notComplete: 'Cows'
              }
            }
          end
          it 'should return a hash with a valid field as false' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:valid]).to eq(false)
          end

          it 'should return the correct paths' do
            return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
            expect(return_value[:invalid_paths]).to eq([[:cats], %i[planning percentComplete]])
          end
        end

        context 'given partially invalid return' do
          let(:invalid_return_data) do
            {
              planning: {

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
        let(:template) do
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

        let(:project_type) { 'cats' }
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

    context 'given a nested array with invalid entries' do
      context 'example one' do
        let(:template) do
          LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                infrastructures: {
                  type: 'array',
                  title: 'Infrastructures',
                  items: {
                    title: 'Infrastructure',
                    type: 'object',
                    properties: {
                      planning: {
                        type: 'object',
                        title: 'Planning',
                        properties: {
                          planningNotGranted: {
                            type: 'object',
                            title: 'Planning Not Granted',
                            properties: {
                              fieldOne: {
                                type: 'object',
                                title: 'Planning Not Granted Field One',
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
                        }
                      }
                    }
                  }
                }
              }
            }
          end
        end
        let(:invalid_return_data) do
          {
            infrastructures: [
              {
                summary: {
                  type: 'A House',
                  description: 'A house of cats'
                },
                planning: {
                  baselineOutlinePlanningPermissionGranted: true,
                  planningNotGranted: {
                    baselineSummaryOfCriticalPath: 'Summary of critical path',
                    fieldOne: {
                      baselineCompletion: {
                        baselineFullPlanningPermissionSubmitted: '2020-01-01',
                        baselineFullPlanningPermissionGranted: '2020-01-01'
                      },
                      fullPlanningPermissionGranted: false,
                      fullPlanningPermissionSummaryOfCriticalPath: 'Summary of critical path'
                    }
                  }
                }
              }
            ]
          }
        end

        it 'should return a hash with a valid field as false' do
          return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
          expect(return_value[:valid]).to eq(false)
        end

        it 'should return the correct path' do
          return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
          expect(return_value[:invalid_paths]).to eq([[:infrastructures, 0, :planning, :planningNotGranted, :fieldOne, :percentComplete]])
        end
      end

      context 'example two' do
        let(:template) do
          LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              properties: {
                cathouses: {
                  type: 'array',
                  title: 'Cat Houses',
                  items: {
                    title: 'Cat House',
                    type: 'object',
                    properties: {
                      catPlanning: {
                        type: 'object',
                        title: 'Cat Planning',
                        properties: {
                          catPlanningNotGranted: {
                            type: 'object',
                            title: 'Cat Planning Not Granted',
                            properties: {
                              catInAHat: {
                                type: 'object',
                                title: 'Its a cat in a hat',
                                required: ['hat'],
                                properties: {
                                  hat: {
                                    type: 'string',
                                    title: 'What a crazy hat'
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          end
        end
        let(:invalid_return_data) do
          {
            cathouses: [
              {
                catPlanning: {
                  catPlanningNotGranted: {
                    catInAHat: {
                      hat: 'Oh my, what a hat'
                    }
                  }
                }
              },
              {
                catPlanning: {
                  catPlanningNotGranted: {
                    catInAHat: {
                    }
                  }
                }
              }
            ]
          }
        end

        it 'should return a hash with a valid field as false' do
          return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
          expect(return_value[:valid]).to eq(false)
        end

        it 'should return the correct path' do
          return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
          expect(return_value[:invalid_paths]).to eq([[:cathouses, 1, :catPlanning, :catPlanningNotGranted, :catInAHat, :hat]])
        end
      end
    end
  end
end
