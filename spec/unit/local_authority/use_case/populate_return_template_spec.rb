# frozen_string_literal: true

describe LocalAuthority::UseCase::PopulateReturnTemplate do
  let(:template_schema) { { properties: {} } }
  let(:matching_baseline_data) { '' }
  let(:copy_paths) { { paths: [{ from: [], to: [] }] } }

  let(:found_template) do
    LocalAuthority::Domain::ReturnTemplate.new.tap do |t|
      t.schema = template_schema
    end
  end
  let(:template_gateway) { spy(find_by: found_template) }
  let(:find_path_data) { spy(execute: { found: matching_baseline_data }) }
  let(:get_schema_copy_paths) { spy(execute: copy_paths) }
  let(:use_case) do
    described_class.new(template_gateway: template_gateway,
    find_path_data: find_path_data,
    get_schema_copy_paths: get_schema_copy_paths)
  end


  context 'finds the template' do
    context 'example 1' do
      it 'finds the correct template for the type' do
        use_case.execute(type: 'hif', baseline_data: {})
        expect(template_gateway).to have_received(:find_by).with(type: 'hif')
      end
    end

    context 'example 2' do
      it 'finds the correct template for the type' do
        baseline_data = {
              names: [
                { pet: 'Mrs Bark' },
                { pet: 'Meow Meow Fuzzyface' }
              ]
            }
        use_case.execute(type: 'cat', baseline_data: baseline_data)
        expect(template_gateway).to have_received(:find_by).with(type: 'cat')
      end
    end
  end

  context 'finds the path' do
    context 'example 1' do
      let(:template_schema) { { properties: {} } }

      it 'finds the correct path' do
        baseline_data = {
              names: [
                { pet: 'Edgar' },
                { pet: 'Barker barkington' }
              ]
            }

        use_case.execute(type: 'cat', baseline_data: baseline_data)
        expect(get_schema_copy_paths).to have_received(:execute).with(type: 'cat')
      end
    end

    context 'example 2' do
      let(:template_schema) { { properties: {} } }

      it 'finds the correct path' do
        baseline_data = {
              names: [
                { pet: 'Mrs Bark' },
                { pet: 'Meow Meow Fuzzyface' }
              ]
            }

        use_case.execute(type: 'dog', baseline_data: baseline_data)
        expect(get_schema_copy_paths).to have_received(:execute).with(type: 'dog')
      end
    end
  end

  context 'Given a single toplevel baseline key in the schema' do
      let(:baseline_data) do
        {
          cats: "Meow"
        }
      end

      let(:template_schema) do
      {
        submissionEstimated: 'baseline data to be copied',
        type: 'object',
        grantEstimated: 'baseline data baseline data to be copied',
        properties:
        {
          noise:
          {
            sourceKey: [:baseline_data, :cats]
          }
        }
      }
    end

    let(:matching_baseline_data) { "Meow" }
    let(:copy_paths) { { paths: [{ from: [:cats], to: [:noise] }] } }

    it 'populates a simple template' do
      result = use_case.execute(type: 'hif', baseline_data: baseline_data)
      expect(result).to eq(populated_data: { noise: "Meow" })
    end
  end

  context 'Given a single multilevel baseline key in the schema' do
      let(:baseline_data) do
        {
          cats: {
            sound: "Meow"
          }
        }
      end

      let(:template_schema) do
      {
        submissionEstimated: 'baseline data to be copied',
        type: 'object',
        grantEstimated: 'baseline data baseline data to be copied',
        properties:
        {
          noise:
          {
            sourceKey: [:baseline_data, :cats, :sound]
          }
        }
      }
    end

    let(:matching_baseline_data) { "Meow" }
    let(:copy_paths) { { paths: [{from: [:cats, :sound], to: [:noise]}] } }

    it 'populates a simple template' do
      result = use_case.execute(type: 'hif', baseline_data: baseline_data)
      expect(result).to eq({ populated_data: {noise: "Meow" } })
    end
  end

  context 'given a return with multiple properties on one level in an array' do
      let(:baseline_data) do
        {
          cats: {
            sound: "Meow",
            breed: "Tabby"
          }
        }
      end

      let(:template_schema) do
      {
        type: 'object',
        properties:
        {
          cat:
          {
            type: 'array',
            items:
            {
              type: 'object',
              properties:
              {
                noise:
                {
                  sourceKey: [:baseline_data, :cats, :sound]
                },
                breed:
                {
                  sourceKey: [:baseline_data, :cats, :breed]
                }
              }
            }
          }
        }

      }
    end

    let(:find_path_data) do
      Class.new do
        def execute(baseline_data, path)
          if path == [:cats, :sound]
            { found: ["Meow"] }
          elsif path == [:cats, :breed]
            {found: ["Tabby"] }
          end
        end
      end.new
    end

    let(:copy_paths) { { paths: [{from: [:cats, :sound], to: [:cat, :noise]},
      {from: [:cats, :breed], to: [:cat,:breed]}] } }

    it 'populates a simple template' do
      result = use_case.execute(type: 'hif', baseline_data: baseline_data)
      expect(result).to eq({ populated_data: {cat: [{noise: 'Meow', breed: 'Tabby'}]}})
    end
  end

  context 'Given a single multilevel return with a baselineKey' do
      let(:baseline_data) do
        {
          cats: {
            sound: "Meow"
          }
        }
      end

      let(:template_schema) do
      {
        submissionEstimated: 'baseline data to be copied',
        type: 'object',
        grantEstimated: 'baseline data baseline data to be copied',
        properties:
        {
          noise:
          {
            type: 'object',
            properties:
            {
              cat: {
                sourceKey: [:baseline_data, :cats, :sound]
              }
            }
          }
        }
      }
    end

    let(:matching_baseline_data) { "Meow" }
    let(:copy_paths) { { paths: [{from: [:cats, :sound], to: [:noise,:cat]}] } }

    it 'populates a simple template' do
      result = use_case.execute(type: 'hif', baseline_data: baseline_data)
      expect(result).to eq({ populated_data: { noise: { cat: "Meow" } }})
    end
  end

  context 'Multiple single level keys in the schema' do
      let(:baseline_data) do
        {
          cats:
          {
            sound: "Meow"
          },
          dogs:
          {
            sound: "Woof"
          }
        }
      end

      let(:template_schema) do
      {
        submissionEstimated: 'baseline data to be copied',
        type: 'object',
        grantEstimated: 'baseline data baseline data to be copied',
        properties:
        {
          cat:
          {
            sourceKey: [:baseline_data, :cats, :sound]
          },
          dog:
          {
            sourceKey: [:baseline_data, :dogs, :sound]
          }
        }
      }
    end
    let(:copy_paths) { { paths: [
      {from: [:cats, :sound], to: [:cat]},
      {from: [:dogs, :sound], to: [:dog]}
    ] } }

    let(:find_path_data) do
      Class.new do
        def execute(baseline_data, path)
          if path == [:cats, :sound]
            { found: "Meow" }
          elsif path == [:dogs, :sound]
            { found: "Woof" }
          end
        end
      end.new
    end

    it 'populates a template' do
      result = use_case.execute(type: 'hif', baseline_data: baseline_data)
      expect(result).to eq(populated_data: { cat: "Meow", dog: "Woof" })
    end
  end

  context 'with an array' do
      let(:baseline_data) do
        {
          cats: [
            {sound: 'Meow'},
            {sound: 'Nyan'}
          ]
        }
      end

      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            kittens:
            {
              type: 'array',
              items:
              {
                type: 'object',
                properties:
                {
                  noise: {
                    sourceKey: [:baseline_data, :cats, :sound]
                  }
                }
              }
            }
          }
        }
      end
    let(:copy_paths) { { paths: [
      {from: [:cats, :sound], to: [:kittens, :noise]}
    ] } }

    let(:matching_baseline_data) { ["Meow","Nyan"] }

    it 'populates a single level template' do
      result = use_case.execute(type: 'hif', baseline_data: baseline_data)
      expect(result).to eq({ populated_data: {kittens: [{noise: "Meow"}, {noise: "Nyan"}]}})
    end
  end

  context 'with a list in an array' do
      let(:baseline_data) do
        {
          cats: [
            {sound: 'Meow'},
            {sound: 'Nyan'}
          ]
        }
      end

      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            kittens:
            {
              type: 'array',
              items:
              {
                type: 'object',
                properties:
                {
                  noises:
                  {
                    type: 'array',
                    items:
                    {
                      type: 'object',
                      properties:
                      {
                        sounds:
                        {
                          sourceKey: [:baseline_data, :cats, :sounds]
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
    let(:copy_paths) { { paths: [
      {from: [:cats, :sounds], to: [:kittens, :noises, :sounds]}
    ] } }

    let(:matching_baseline_data) { [["Meow","Nyan"],["Eow","Nya"]] }

    it 'populates a single level template' do
      result = use_case.execute(type: 'hif', baseline_data: baseline_data)
      expect(result).to eq({ populated_data: {
        kittens:
        [
          {
            noises:
            [
              {sounds: "Meow"},
              {sounds: "Nyan"}
            ]
          },
          {
            noises:
            [
              {sounds: "Eow"},
              {sounds: "Nya"},
            ]
          }
        ]
      }}
      )
    end
  end

  context 'Creating a return from another return' do
    let(:template_schema) do
      {
        type: 'object',
        properties:
        {
          noise:
          {
            sourceKey: [:return_data, :cat]
          }
        }
      }
    end

    let(:baseline_data) { {} }
    let(:return_data) do
      {
        cat: "Meow"
      }
    end

    let(:copy_paths) do
        {
          paths:
          [
            {from: [:return_data, :cat], to: [:noise]}
          ]
        }
    end

    let(:matching_baseline_data) { "Meow" }

    it 'is a simple return' do
      result = use_case.execute(type: 'hif', baseline_data: baseline_data, return_data: return_data)
      expect(result).to eq(populated_data: { noise: "Meow" })
    end
  end

  context 'creating a return to a non-existent simple two level path' do
    let(:template_schema) do
      {
        type: 'object',
        properties:
        {
          cat:
          {
            sourceKey: [:return_data, :cats, :name]
          }
        }
      }
    end

    let(:baseline_data) { {} }
    let(:return_data) { {cats: []} }

    let(:copy_paths) do
        {
          paths:
          [
            {from: [:return_data, :cats, :name], to: [:cat,:something]}
          ]
        }
    end

    it 'gives an empty populated_data' do
      result = use_case.execute(type: 'hif', baseline_data: baseline_data, return_data: return_data)
      expect(result).to eq(populated_data: {})
    end
  end

  context 'creating a return with a non-existent source path that contains an array' do
    let(:template_schema) do
      {
        type: 'object',
        properties:
        {
          cats:
          {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                cat: {
                  sourceKey: [:baseline_data, :cats, :name]
                }
              }
            }
          }
        }
      }
    end

    let(:matching_baseline_data) { "Meow" }
    let(:baseline_data) { {cats: [{name: "Meow"}]} }
    let(:return_data) { {} }

    let(:copy_paths) do
        {
          paths:
          [
            {from: [:return_data, :cats, :name], to: [:cats,:cat]}
          ]
        }
    end

    it 'gives an empty populated_data' do
      result = use_case.execute(type: 'hif', baseline_data: baseline_data, return_data: return_data)
      expect(result).to eq(populated_data: {cats: []})
    end
  end

  context 'creating a return with a path in a dependency' do
    let(:template_schema) do
      {
        type: 'object',
        dependencies:
        {
          cats:
          {
            oneOf: [
              {
                type: 'object',
                properties: {
                  cat: {
                    sourceKey: [:baseline_data, :cats, :name]
                  }
                }
              }
            ]
          }
        }
      }
    end

    let(:baseline_data) { {cats: {name: "tom"}} }
    let(:matching_baseline_data) { "tom" }
    let(:return_data) { {} }

    let(:copy_paths) do
        {
          paths:
          [
            {from: [:return_data, :cats, :name], to: [:cat]}
          ]
        }
    end

    it 'gives an empty populated_data' do
      result = use_case.execute(type: 'hif', baseline_data: baseline_data, return_data: return_data)
      expect(result).to eq(populated_data: {cat: "tom"})
    end
  end

  context 'creating a return with a path in a dependency in an array' do
    let(:template_schema) do
      {
        type: 'object',
        properties: {
          top: {
            type: 'array',
            items: {
              type: 'object',
              properties: {

              },
              dependencies:
              {
                cats:
                {
                  oneOf: [
                    {
                      type: 'object',
                      properties: {
                        name: {
                          sourceKey: [:baseline_data, :cats, :name]
                        }
                      }
                    }
                  ]
                }
              }
            }
          }
        }
      }
    end

    let(:baseline_data) {  {cats: {name: "tom"}} }
    let(:matching_baseline_data) { ["tom"] }
    let(:return_data) { {} }

    let(:copy_paths) do
      {
        paths:
        [
          {from: [:baseline_data, :cats, :name], to: [:top, :name]}
        ]
      }
    end

    it 'gives appropriate data' do
      result = use_case.execute(type: 'hif', baseline_data: baseline_data, return_data: return_data)
      expect(result).to eq(populated_data: {top: [{name: "tom"}]})
    end
  end

  context 'given a schema with multiple states' do
    let(:template_schema) do
      {
        type: 'object',
        properties: {
          top: {
            type: 'object',
            properties: {

            },
            dependencies:
            {
              dogs:
              {
                oneOf: [
                  {
                    type: 'object',
                    properties: {
                      name: {
                        sourceKey: [:baseline_data, :dogs, :name]
                      }
                    }
                  },
                  {
                    type: 'object',
                    properties: {
                      breed: {
                        type: 'string'
                      }
                    }
                  }
                ]
              }
            }
          }
        }
      }
    end

    let(:baseline_data) {  {dogs: {name: "tom"}} }
    let(:matching_baseline_data) { "tom" }
    let(:return_data) { {} }

    let(:copy_paths) do
      {
        paths:
        [
          {from: [:baseline_data, :dogs, :name], to: [:top, :name]}
        ]
      }
    end

    it 'gives appropriate data' do
      result = use_case.execute(type: 'hif', baseline_data: baseline_data, return_data: return_data)
      expect(result).to eq(populated_data: {top: {name: "tom"}})
    end
  end
end
