describe LocalAuthority::UseCase::GetReturnTemplatePathTitles do
  let(:template_schema) { {} }
  let(:found_template) do
    LocalAuthority::Domain::ReturnTemplate.new.tap do |t|
      t.schema = template_schema
    end
  end

  let(:template_gateway_spy) { spy(find_by: found_template) }
  let(:use_case) { described_class.new(template_gateway: template_gateway_spy) }

  context 'calls the template gateway' do
    it 'example 1' do
      use_case.execute(type: 'hif', path: [])
      expect(template_gateway_spy).to have_received(:find_by).with(type: 'hif')
    end

    it 'example 2' do
      use_case.execute(type: 'hw35', path: [])
      expect(template_gateway_spy).to have_received(:find_by).with(type: 'hw35')
    end
  end

  context 'simple schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'template',
          type: 'object',
          properties:
          {
            noise: {
              title: "Noise"
            }
          }
        }
      end

      it 'gets the correct path names' do
        path_titles = use_case.execute(type: 'hw35', path: [:noise])[:path_titles]
        expect(path_titles).to eq(['template', 'Noise'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'Head',
          type: 'object',
          properties:
          {
            dog: {
              title: 'Body'
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: [:dog])[:path_titles]
        expect(path_titles).to eq(['Head','Body'])
      end
    end
  end

  context 'simple schema with missing titles' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'template',
          type: 'object',
          properties:
          {
            noise: {
            }
          }
        }
      end

      it 'gets the correct path names' do
        path_titles = use_case.execute(type: 'hw35', path: [:noise])[:path_titles]
        expect(path_titles).to eq(['template', '[noise]'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'Head',
          type: 'object',
          properties:
          {
            dog: {
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: [:dog])[:path_titles]
        expect(path_titles).to eq(['Head', '[dog]'])
      end
    end
  end

  context 'simple schema with missing top level titles' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            noise: {
            }
          }
        }
      end

      it 'gets the correct path names' do
        path_titles = use_case.execute(type: 'hw35', path: [:noise])[:path_titles]
        expect(path_titles).to eq(['[form]', '[noise]'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            dog: {
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: [:dog])[:path_titles]
        expect(path_titles).to eq(['[form]', '[dog]'])
      end
    end
  end

  context 'deep schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'Title',
          type: 'object',
          properties:
          {
            cat: {
              title: 'Cat Title',
              type: 'object',
              properties: {
                noise: {
                  title: 'Noise Title',
                  type: 'object',
                  properties: {
                    averageAmplitude: {
                      title: 'Average Amplitude Title'
                    }
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[cat noise averageAmplitude])[:path_titles]
        expect(path_titles).to eq(['Title', 'Cat Title', 'Noise Title', 'Average Amplitude Title'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'Cat',
          type: 'object',
          properties:
          {
            dog: {
              title: 'Dog',
              type: 'object',
              properties: {
                noise: {
                  title: 'Noise',
                  type: 'object',
                  properties: {
                    averageAmplitude: {
                      title: 'Average Amplitude',
                      type: 'object',
                      precision: {
                      }
                    }
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[dog noise averageAmplitude])[:path_titles]
        expect(path_titles).to eq(['Cat', 'Dog', 'Noise', 'Average Amplitude'])
      end
    end
  end

  context 'simple array schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'cats',
          type: 'object',
          properties:
          {
            dog: {
              title: 'dogs',
              type: 'array',
              items: {
                title: 'doge',
                type: 'object',
                properties: {
                  noise: {
                    title: 'noise'
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: [:dog, 0, :noise])[:path_titles]
        expect(path_titles).to eq(['cats', 'dogs', 'doge 1', 'noise'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'Top level',
          type: 'object',
          properties:
          {
            cat: {
              title: 'cat array',
              type: 'array',
              items: {
                title: 'cat item',
                type: 'object',
                properties: {
                  noise: {
                    title: 'noise'
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: [:cat, 1, :noise])[:path_titles]
        expect(path_titles).to eq(['Top level', 'cat array', 'cat item 2', 'noise'])
      end
    end
  end

  context 'simple array schema with missing titles' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            dog: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  noise: {
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[dog noise])[:path_titles]
        expect(path_titles).to eq(['[form]', '[dog]', '[item]', '[noise]'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            cat: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  noise: {
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[cat noise])[:path_titles]
        expect(path_titles).to eq(['[form]', '[cat]', '[item]', '[noise]'])
      end
    end
  end

  context 'simple array schema with some missing titles' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            dog: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  noise: {
                    title: 'Hey'
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[dog noise])[:path_titles]
        expect(path_titles).to eq(['[form]', '[dog]', '[item]', 'Hey'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            cat: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  noise: {
                  }
                }
              }
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[cat noise])[:path_titles]
        expect(path_titles).to eq(['[form]', '[cat]', '[item]', '[noise]'])
      end
    end
  end

  context 'simple dependency schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'header',
          type: 'object',
          properties:
          {
            noise: {}
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    cat: {
                      title: 'Cats'
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[cat])[:path_titles]
        expect(path_titles).to eq(['header', 'Cats'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'cats',
          type: 'object',
          properties:
          {
            noise: {}
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    dog: {
                      title: 'dog'
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[dog])[:path_titles]
        expect(path_titles).to eq(['cats', 'dog'])
      end
    end
  end

  context 'simple dependency schema without titles' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            noise: {}
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    cat: {
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[cat])[:path_titles]
        expect(path_titles).to eq(['[form]', '[cat]'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            noise: {}
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    dog: {
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[dog])[:path_titles]
        expect(path_titles).to eq(['[form]', '[dog]'])
      end
    end
  end

  context 'complex dependency schema with array' do
    context 'example 1' do
      let(:template_schema) do
        {
          title: 'Optional',
          type: 'object',
          properties:
          {
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    cat: {
                      title: 'Cats',
                      type: 'array',
                      items:
                      {
                        title: 'Cat',
                        type: 'object',
                        properties: {
                          noise: {
                            title: 'Noise'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[cat noise])[:path_titles]
        expect(path_titles).to eq(['Optional', 'Cats', 'Cat', 'Noise'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          title: 'Dog Header',
          type: 'object',
          properties:
          {
            dogs: {}
          },
          dependencies:
          {
            dogs:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    dog: {
                      title: 'Dogs',
                      type: 'array',
                      items:
                      {
                        title: 'Dog',
                        type: 'object',
                        properties: {
                          sound: {
                            title: 'Sound'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[dog sound])[:path_titles]
        expect(path_titles).to eq(['Dog Header', 'Dogs', 'Dog', 'Sound'])
      end
    end
  end

  context 'complex dependency schema with array with missing titles' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
          },
          dependencies:
          {
            cats:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    cat: {
                      type: 'array',
                      items:
                      {
                        type: 'object',
                        properties: {
                          noise: {
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[cat noise])[:path_titles]
        expect(path_titles).to eq(['[form]', '[cat]', '[item]', '[noise]'])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            dogs: {}
          },
          dependencies:
          {
            dogs:
            {
              oneOf: [
                {
                  type: 'object',
                  properties: {
                    dog: {
                      type: 'array',
                      items:
                      {
                        type: 'object',
                        properties: {
                          sound: {
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      end

      it 'gets the correct path titles' do
        path_titles = use_case.execute(type: 'hif', path: %i[dog sound])[:path_titles]
        expect(path_titles).to eq(['[form]', '[dog]', '[item]', '[sound]'])
      end
    end
  end
end
