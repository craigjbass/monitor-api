# frozen_string_literal: true

describe LocalAuthority::UseCase::ValidateReturn do
  let(:project_type) { 'hif' }
  let(:template) do
    LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
      p.schema = {}
    end
  end

  let(:invalid_return_data_paths) { nil }

  let(:return_template_gateway_spy) { double(find_by: template) }
  let(:use_case) do
    described_class.new(return_template_gateway: return_template_gateway_spy)
  end

  it 'should have accept project type and return data' do
    use_case.execute(type: project_type, return_data: {})
  end

  context 'calling return template gateway' do
    context 'example 1' do
      let(:project_type) { 'cats' }
      it 'should call return template gateway with type' do
        use_case.execute(type: project_type, return_data: {})
        expect(return_template_gateway_spy).to have_received(:find_by).with(type: project_type)
      end
    end

    context 'example 2' do
      let(:project_type) { 'dogs' }
      it 'should call return template gateway with type' do
        use_case.execute(type: project_type, return_data: {})
        expect(return_template_gateway_spy).to have_received(:find_by).with(type: project_type)
      end
    end
  end

  shared_examples_for 'required field validation' do
    context 'given a valid return' do
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
      it 'should return a hash with a valid field as false' do
        return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
        expect(return_value[:valid]).to eq(false)
      end

      it 'should return the correct path' do
        return_value = use_case.execute(type: project_type, return_data: invalid_return_data)
        expect(return_value[:invalid_paths]).to eq(invalid_return_data_paths)
      end
    end
  end

  context 'required field validation' do
    context 'nils should be acceptable values' do
      context 'example 1' do
        it_should_behave_like 'required field validation'
        let(:template) do
          LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
            p.schema = {
              title: 'HIF Project',
              type: 'object',
              required: [:complete],
              properties: {
                complete: {
                  type: 'boolean',
                  title: 'Complete'
                }
              }
            }
          end
        end

        let(:valid_return_data) do
          {
            complete: nil
          }
        end

        let(:invalid_return_data) do
          {

          }
        end

        let(:invalid_return_data_paths) do
          [[:complete]]
        end
      end
    end
    context 'single field' do
      context 'example 1' do
        it_should_behave_like 'required field validation'
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

        let(:valid_return_data) do
          {
            percentComplete: 99
          }
        end

        let(:invalid_return_data) do
          {

          }
        end

        let(:invalid_return_data_paths) do
          [[:percentComplete]]
        end
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'
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

        let(:valid_return_data) do
          {
            catsComplete: 'The Cat Plan'
          }
        end

        let(:invalid_return_data) do
          {

          }
        end

        let(:invalid_return_data_paths) do
          [[:catsComplete]]
        end
      end
    end

    context 'given a nested field' do
      context 'example 1' do
        it_should_behave_like 'required field validation'

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

        let(:valid_return_data) do
          {
            planning: {
              percentComplete: 99
            }
          }
        end

        let(:invalid_return_data) do
          {
            planning: {

            }
          }
        end

        let(:invalid_return_data_paths) { [%i[planning percentComplete]] }
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'
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

        let(:valid_return_data) do
          {
            planning: {
              catsComplete: 'The Cat Plan'
            }
          }
        end

        let(:invalid_return_data) do
          {
            planning: {}
          }
        end

        let(:invalid_return_data_paths) { [%i[planning catsComplete]] }
      end
    end

    context 'given a nested field with an array' do
      context 'example 1' do
        it_should_behave_like 'required field validation'
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

        let(:invalid_return_data) { {} }

        let(:valid_return_data) do
          {
            cats: [{ name: 'Love the hats' }]
          }
        end

        let(:invalid_return_data_paths) { [[:cats]] }
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'
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
        let(:invalid_return_data) { {} }
        let(:valid_return_data) do
          {
            dogs: [{ name: 'Love the hats' }]
          }
        end

        let(:invalid_return_data_paths) { [[:dogs]] }
      end
    end

    context 'given an array with a nested invalid field' do
      context 'example 1' do
        it_should_behave_like 'required field validation'
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

        let(:invalid_return_data) do
          {
            dogs: [{}]
          }
        end

        let(:valid_return_data) do
          {
            dogs: [{ name: 'Scout, The Dog.' }]
          }
        end

        let(:invalid_return_data_paths) { [[:dogs, 0, :name]] }
      end

      context 'example 2' do
        it_should_behave_like 'required field validation'
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

        let(:invalid_return_data) do
          {
            cats: [{ catName: 'Hello' }, {}]
          }
        end

        let(:valid_return_data) do
          {
            cats: [{ catName: 'Scout, The Cat.' }, { catName: 'Robin, The Cat.' }]
          }
        end

        let(:invalid_return_data_paths) { [[:cats, 1, :catName]] }
      end
    end

    context 'given a nested field with multiple entries' do
      context 'example 1' do
        it_should_behave_like 'required field validation'

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

        let(:valid_return_data) do
          {
            planning: {
              percentComplete: 99
            },
            cats: 'Love the hats'
          }
        end

        let(:invalid_return_data) do
          {
            planning: {
              notComplete: 'Cows'
            }
          }
        end

        let(:invalid_return_data_paths) { [[:cats], %i[planning percentComplete]] }

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

      context 'example 2' do
        it_should_behave_like 'required field validation'

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

        let(:valid_return_data) do
          {
            planning: {
              catsComplete: 'The Cat Plan'
            },
            dogs: 'Scout, The Dog, was here'
          }
        end

        let(:invalid_return_data) do
          {
            planning: {
              catsComplete: '',
              theAnswer: 43
            }
          }
        end
        let(:invalid_return_data_paths) { [[:dogs]] }
      end
    end

    context 'given a nested array with invalid entries' do
      context 'example 1' do
        it_should_behave_like 'required field validation'

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

        let(:valid_return_data) do
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
                      fullPlanningPermissionSummaryOfCriticalPath: 'Summary of critical path',
                      percentComplete: 8
                    }
                  }
                }
              }
            ]
          }
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

        let(:invalid_return_data_paths) do
          [[:infrastructures, 0, :planning, :planningNotGranted, :fieldOne, :percentComplete]]
        end
      end
      context 'example 2' do
        it_should_behave_like 'required field validation'

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
        let(:valid_return_data) do
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
                      hat: 'Cat'
                    }
                  }
                }
              }
            ]
          }
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
      end
      let(:invalid_return_data_paths) do
        [[:cathouses, 1, :catPlanning, :catPlanningNotGranted, :catInAHat, :hat]]
      end
    end
  end
end
