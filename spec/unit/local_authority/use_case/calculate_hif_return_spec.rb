# frozen_string_literal: true

require 'rspec'

describe LocalAuthority::UseCase::CalculateHIFReturn do
  let(:use_case) { described_class.new }
  it 'will return an empty array given empty data' do
    expected_return_data = {
      infrastructures: []
    }
    return_data = use_case.execute(return_data_with_no_calculations: {}, previous_return: {})
    expect(return_data[:calculated_return]).to eq(expected_return_data)
  end

  context 'example one' do
    it 'should retain the original data' do
      expected_return_data = {
        infrastructures: [
          {
            planning: {
              planningNotGranted: {
                fieldOne: {
                  returnInput: {
                    currentReturn: '18/08/2000'
                  },
                  varianceCalculations: {
                    varianceAgainstLastReturn: {
                      varianceLastReturnFullPlanningPermissionSubmitted: nil
                    }
                  }
                }
              }
            }
          }
        ]
      }

      return_data_with_no_calculation = {
        infrastructures: [
          {
            planning: {
              planningNotGranted: {
                fieldOne: {
                  returnInput: {
                    currentReturn: '18/08/2000'
                  },
                  varianceCalculations: {
                    varianceAgainstLastReturn: {
                      varianceLastReturnFullPlanningPermissionSubmitted: nil
                    }
                  }
                }
              }
            }
          }
        ]
      }

      return_data = use_case.execute(
        return_data_with_no_calculations: return_data_with_no_calculation, previous_return: {}
      )
      expect(return_data[:calculated_return]).to eq(expected_return_data)
    end
  end

  context 'example two' do
    it 'should retain the original data' do
      expected_return_data = {
        infrastructures: [
          {
            planning: {
              planningNotGranted: {
                fieldOne: {
                  returnInput: {
                    currentReturn: '03/11/1982'
                  },
                  varianceCalculations: {
                    varianceAgainstLastReturn: {
                      varianceLastReturnFullPlanningPermissionSubmitted: nil
                    }
                  }
                }
              }
            }
          }
        ]
      }

      return_data_with_no_calculation = {
        infrastructures: [
          {
            planning: {
              planningNotGranted: {
                fieldOne: {
                  returnInput: {
                    currentReturn: '03/11/1982'
                  }
                }
              }
            }
          }
        ]
      }

      return_data = use_case.execute(
        return_data_with_no_calculations: return_data_with_no_calculation,
        previous_return: {}
      )
      expect(return_data[:calculated_return]).to eq(expected_return_data)
    end
  end

  context 'varianceLastReturnFullPlanningPermissionSubmitted' do
    context 'example one' do
      it 'should return a populated field if there is previous return data' do
        expected_return_data = {
          infrastructures: [
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '03/11/1982'
                    },
                    varianceCalculations: {
                      varianceAgainstLastReturn: {
                        varianceLastReturnFullPlanningPermissionSubmitted: '1'
                      }
                    }
                  }
                }
              }
            }
          ]
        }

        return_data_with_no_calculation = {
          infrastructures: [
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '03/11/1982'
                    }
                  }
                }
              }
            }
          ]
        }

        previous_return = {
          infrastructures: [
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '25/10/1982'
                    }
                  }
                }
              }
            }
          ]
        }

        return_data = use_case.execute(
          return_data_with_no_calculations: return_data_with_no_calculation,
          previous_return: previous_return
        )
        expect(return_data[:calculated_return]).to eq(expected_return_data)
      end
    end

    context 'example two' do
      it 'should return a populated field if there is previous return data' do
        expected_return_data = {
          infrastructures: [
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '03/11/1982'
                    },
                    varianceCalculations: {
                      varianceAgainstLastReturn: {
                        varianceLastReturnFullPlanningPermissionSubmitted: '2'
                      }
                    }
                  }
                }
              }
            }
          ]
        }

        return_data_with_no_calculation = {
          infrastructures: [
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '03/11/1982'
                    }
                  }
                }
              }
            }
          ]
        }

        previous_return = {
          infrastructures: [
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '18/10/1982'
                    }
                  }
                }
              }
            }
          ]
        }

        return_data = use_case.execute(
          return_data_with_no_calculations: return_data_with_no_calculation,
          previous_return: previous_return
        )
        expect(return_data[:calculated_return]).to eq(expected_return_data)
      end
    end
  end

  context 'multiple varianceLastReturnFullPlanningPermissionSubmitted' do
    context 'example one' do
      it 'should return a populated field if there is previous return data' do
        expected_return_data = {
          infrastructures: [
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '03/11/1982'
                    },
                    varianceCalculations: {
                      varianceAgainstLastReturn: {
                        varianceLastReturnFullPlanningPermissionSubmitted: '1'
                      }
                    }
                  }
                }
              }
            },
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '05/11/1990'
                    },
                    varianceCalculations: {
                      varianceAgainstLastReturn: {
                        varianceLastReturnFullPlanningPermissionSubmitted: '2'
                      }
                    }
                  }
                }
              }
            }
          ]
        }

        return_data_with_no_calculation = {
          infrastructures: [
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '03/11/1982'
                    }
                  }
                }
              }
            },
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '05/11/1990'
                    }
                  }
                }
              }
            }
          ]
        }

        previous_return = {
          infrastructures: [
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '25/10/1982'
                    }
                  }
                }
              }
            },
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '28/10/1982'
                    }
                  }
                }
              }
            }
          ]
        }

        return_data = use_case.execute(
          return_data_with_no_calculations: return_data_with_no_calculation,
          previous_return: previous_return
        )

        expect(return_data[:calculated_return]).to eq(expected_return_data)
      end
    end

    context 'example two' do
      it 'should return a populated field if there is previous return data' do
        expected_return_data = {
          infrastructures: [
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '03/11/1982'
                    },
                    varianceCalculations: {
                      varianceAgainstLastReturn: {
                        varianceLastReturnFullPlanningPermissionSubmitted: '1'
                      }
                    }
                  }
                }
              }
            },
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '05/11/1990'
                    },
                    varianceCalculations: {
                      varianceAgainstLastReturn: {
                        varianceLastReturnFullPlanningPermissionSubmitted: '3'
                      }
                    }
                  }
                }
              }
            }
          ]
        }

        return_data_with_no_calculation = {
          infrastructures: [
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '03/11/1982'
                    }
                  }
                }
              }
            },
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '05/11/1990'
                    }
                  }
                }
              }
            }
          ]
        }

        previous_return = {
          infrastructures: [
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '25/10/1982'
                    }
                  }
                }
              }
            },
            {
              planning: {
                planningNotGranted: {
                  fieldOne: {
                    returnInput: {
                      currentReturn: '21/10/1990'
                    }
                  }
                }
              }
            }
          ]
        }

        return_data = use_case.execute(
          return_data_with_no_calculations: return_data_with_no_calculation,
          previous_return: previous_return
        )

        expect(return_data[:calculated_return]).to eq(expected_return_data)
      end
    end
  end
end
