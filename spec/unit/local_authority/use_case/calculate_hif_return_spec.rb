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
      let(:expected_return_data) do
        {
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
      end

      let(:return_data_with_no_calculation) do
        {
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
      end

      let(:previous_return) do
        {
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
      end

      let(:return_data) do
        use_case.execute(
          return_data_with_no_calculations: return_data_with_no_calculation,
          previous_return: previous_return
        )
      end

      before { return_data }

      it 'should return a populated field if there is previous return data' do
        expect(return_data[:calculated_return]).to eq(expected_return_data)
      end

      it 'should not mutate the request hash' do
        expect(return_data_with_no_calculation).not_to(
          eq(return_data[:calculated_return])
        )
      end
    end
  end

  context 'varianceAgainstForcast' do
    context ' in S151:supportingEvidence:lastQuarterMonthSpend forecast and amount are present' do
      context 'example one' do
        it 'should return a propulated varianceAgainstForcast amount and percentage' do
          expected_return_data = {
            infrastructures: [],
            s151: {
              supportingEvidence: {
                lastQuarterMonthSpend: {
                  forecast: '10000',
                  actual: '9000',
                  hasVariance: 'Yes',
                  varianceAgainstForcastAmount: '1000',
                  varianceAgainstForcastPercentage: '10' 
                }
              }
            }
          }

          return_data_with_no_calculations = {
            s151: {
              supportingEvidence: {
                lastQuarterMonthSpend: {
                  forecast: '10000',
                  actual: '9000'
                }
              }
            }
          }

          previous_return = {}

          return_data = use_case.execute(
            return_data_with_no_calculations: return_data_with_no_calculations,
            previous_return: previous_return
          )

          expect(return_data[:calculated_return]).to eq(expected_return_data)
        end
      end

      context 'example two' do
        it 'should return a propulated varianceAgainstForcast amount and percentage' do
          expected_return_data = {
            infrastructures: [],
            s151: {
              supportingEvidence: {
                lastQuarterMonthSpend: {
                  forecast: '25,000',
                  actual: '5,000',
                  hasVariance: 'Yes',
                  varianceAgainstForcastAmount: '20000',
                  varianceAgainstForcastPercentage: '80' 
                }
              }
            }
          }

          return_data_with_no_calculations = {
            s151: {
              supportingEvidence: {
                lastQuarterMonthSpend: {
                  forecast: '25,000',
                  actual: '5,000'
                }
              }
            }
          }

          previous_return = {}

          return_data = use_case.execute(
            return_data_with_no_calculations: return_data_with_no_calculations,
            previous_return: previous_return
          )

          expect(return_data[:calculated_return]).to eq(expected_return_data)
        end
      end
    end

    context ' in S151:supportingEvidence:lastQuarterMonthSpend forecast and amount are not present' do
      context 'example one' do
        it 'should return a propulated varianceAgainstForcast amount and percentage' do
          expected_return_data = {
            infrastructures: [],
            s151: {
              supportingEvidence: {
                lastQuarterMonthSpend: {
                  forecast: nil,
                  actual: nil,
                }
              }
            }
          }

          return_data_with_no_calculations = {
            s151: {
              supportingEvidence: {
                lastQuarterMonthSpend: {
                  forecast: nil,
                  actual: nil
                }
              }
            }
          }

          previous_return = {}

          return_data = use_case.execute(
            return_data_with_no_calculations: return_data_with_no_calculations,
            previous_return: previous_return
          )

          expect(return_data[:calculated_return]).to eq(expected_return_data)
        end
      end

      context 'example two' do
        it 'should return a propulated varianceAgainstForcast amount and percentage' do
          expected_return_data = {
            infrastructures: [],
            s151: {
              supportingEvidence: {
                lastQuarterMonthSpend: {
                  forecast: nil,
                  actual: nil,
                }
              }
            }
          }

          return_data_with_no_calculations = {
            s151: {
              supportingEvidence: {
                lastQuarterMonthSpend: {
                  forecast: nil,
                  actual: nil
                }
              }
            }
          }

          previous_return = {}

          return_data = use_case.execute(
            return_data_with_no_calculations: return_data_with_no_calculations,
            previous_return: previous_return
          )

          expect(return_data[:calculated_return]).to eq(expected_return_data)
        end
      end
    end

    context ' in S151:supportingEvidence:lastQuarterMonthSpend forecast and amount are the same' do
      context 'example one' do
        it 'should return a propulated varianceAgainstForcast amount and percentage' do
          expected_return_data = {
            infrastructures: [],
            s151: {
              supportingEvidence: {
                lastQuarterMonthSpend: {
                  forecast: '7',
                  actual: '7',
                  hasVariance: 'No'
                }
              }
            }
          }

          return_data_with_no_calculations = {
            s151: {
              supportingEvidence: {
                lastQuarterMonthSpend: {
                  forecast: '7',
                  actual: '7'
                }
              }
            }
          }

          previous_return = {}

          return_data = use_case.execute(
            return_data_with_no_calculations: return_data_with_no_calculations,
            previous_return: previous_return
          )

          expect(return_data[:calculated_return]).to eq(expected_return_data)
        end
      end

      context 'example two' do
        it 'should return a propulated varianceAgainstForcast amount and percentage' do
          expected_return_data = {
            s151: {
              supportingEvidence: {
                lastQuarterMonthSpend: {
                  forecast: '10',
                  actual: '10',
                  hasVariance: 'No'
                }
              }
            },
            infrastructures: []
          }

          return_data_with_no_calculations = {
            s151: {
              supportingEvidence: {
                lastQuarterMonthSpend: {
                  forecast: '10',
                  actual: '10'
                }
              }
            }
          }

          previous_return = {}

          return_data = use_case.execute(
            return_data_with_no_calculations: return_data_with_no_calculations,
            previous_return: previous_return
          )

          expect(return_data[:calculated_return][:s151]).to eq(expected_return_data[:s151])
        end
      end
    end
  end
end
