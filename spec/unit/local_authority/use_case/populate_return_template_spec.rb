# frozen_string_literal: true

# No baselineKey? 
# Arrays

describe LocalAuthority::UseCase::PopulateReturnTemplate do
  let(:template_gateway_spy) { spy(find_by: found_template) }
  let(:template_schema) { {properties: {}} }
  let(:use_case) { described_class.new(template_gateway: template_gateway_spy) }

  def get_response(baseline_data)
    use_case.execute(type: type, baseline_data: baseline_data)[:populated_data]
  end
  
  context 'Example one' do
    let(:type) { 'hif' }
    let(:found_template) do
      LocalAuthority::Domain::ReturnTemplate.new.tap do |t|
        t.schema = template_schema
      end
    end

    it 'Finds the correct template for the type' do
      use_case.execute(type: 'hif', baseline_data: {})
      expect(template_gateway_spy).to have_received(:find_by).with(type: 'hif')
    end

    context 'Given a single toplevel baseline key in the schema' do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            noise: {
              baselineKey: ['cats']
            }
          }
        }
      end

      it 'Returns a hash containing the data from the baseline' do
        baseline_data = { cats: 'meow' }
        response = get_response(baseline_data)

        expect(response).to eq(noise: 'meow')
      end
    end
    
    context 'Given multiple toplevel baseline keys in the schema' do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            catNoise: {
              baselineKey: ['cats']
            },
            dogNoise: {
              baselineKey: ['dogs']
            },
            cowNoise: {
              baselineKey: ['cows']
            }
          }
        }
      end

      it 'Returns a hash containing the data from the baseline' do
        baseline_data = { cats: 'meow', dogs: 'woof', cows: 'moo' }
        response = get_response(baseline_data)

        expect(response).to eq(catNoise: 'meow', dogNoise: 'woof', cowNoise: 'moo')
      end
    end

    context 'Given nested baseline data for a top level key' do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            catNoise: {
              baselineKey: ['noises', 'cat']
            }
          }
        }
      end

      it 'Returns a hash containing the data from the baseline' do
        baseline_data = { noises: { cat: 'meow' } }
        response = get_response(baseline_data)

        expect(response).to eq(catNoise: 'meow')
      end
    end

    context 'Given baseline data for a nested schema key' do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            cat: {
              type: 'object',
              properties: {
                noise: {
                  baselineKey: ['noises', 'cat']
                }
              }
            }
          }
        }
      end

      it 'Returns a hash containing the data from the baseline' do
        baseline_data = { noises: { cat: 'meow' } }
        response = get_response(baseline_data)

        expect(response).to eq(cat: { noise: 'meow' })
      end
    end

    context 'Given a single toplevel key in the schema with no baseline key' do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            noise: {
            }
          }
        }
      end

      it 'Returns a hash blank data for the schema key' do
        baseline_data = { cats: 'meow' }
        response = get_response(baseline_data)

        expect(response).to eq(noise: nil)
      end
    end

    context 'Given a baseline key inside an array', focus: true do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            animals: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  animalName: { baselineKey: ['pets', 'animalType']}
                }
              }
            }
          }
        }
      end

      context 'With a single item in the baseline data' do
        it 'Returns a hash containing an array with one item populated from the baseline' do
          baseline_data = {
            pets: [
              { animalType: 'cat' }
            ]
          }
          response = get_response(baseline_data)
  
          expect(response).to eq(animals: [ { animalName: 'cat' }])
        end
      end
      
      context 'With a two items in the baseline data' do
        it 'Returns a hash containing an array with two items populated from the baseline' do
          baseline_data = {
            pets: [
              { animalType: 'cat' },
              { animalType: 'dog' }
            ]
          }
          response = get_response(baseline_data)
  
          expect(response).to eq(animals: [{ animalName: 'cat' }, {animalName: 'dog' }])
        end
      end
    end
  end

  context 'Example two' do
    let(:type) { 'cats' }
    let(:found_template) do
      LocalAuthority::Domain::ReturnTemplate.new.tap do |t|
        t.schema = template_schema
      end
    end

    it 'Finds the correct template for the type' do
      use_case.execute(type: 'cats', baseline_data: {})
      expect(template_gateway_spy).to have_received(:find_by).with(type: 'cats')
    end

    context 'Given a single toplevel baseline key in the schema' do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            name: {
              baselineKey: ['petName']
            }
          }
        }
      end

      it 'Returns a hash containing the data from the baseline' do
        baseline_data = { petName: 'Sir Barkington' }
        response = get_response(baseline_data)

        expect(response).to eq(name: 'Sir Barkington')
      end
    end

    context 'Given multiple toplevel baseline keys in the schema' do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            catName: {
              baselineKey: ['cat']
            },
            dogName: {
              baselineKey: ['dog']
            },
            cowName: {
              baselineKey: ['cow']
            }
          }
        }
      end

      it 'Returns a hash containing the data from the baseline' do
        baseline_data = { cat: 'Mr Bigglesworth', dog: 'Sir Barkington', cow: 'Cow King' }
        response = get_response(baseline_data)

        expect(response).to eq(
          catName: 'Mr Bigglesworth', 
          dogName: 'Sir Barkington', 
          cowName: 'Cow King'
        )
      end
    end

    context 'Given nested baseline data for a top level key' do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            dogSound: {
              baselineKey: ['animals', 'sounds', 'dogs']
            }
          }
        }
      end

      it 'Returns a hash containing the data from the baseline' do
        baseline_data = { animals: { sounds: { dogs: 'woof' } } }
        response = get_response(baseline_data)

        expect(response).to eq(dogSound: 'woof')
      end
    end

    context 'Given a baseline key inside an array', focus: true do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            family: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  petNames: { baselineKey: ['names', 'pet']}
                }
              }
            }
          }
        }
      end

      context 'With a single item in the baseline data', focus: true do
        it 'Returns a hash containing an array with one item populated from the baseline' do
          baseline_data = {
            names: [
              { pet: 'Mr Bark' }
            ]
          }
          response = get_response(baseline_data)
  
          expect(response).to eq(family: [ { petNames: 'Mr Bark' }])
        end
      end
      
      context 'With a two items in the baseline data' do
        it 'Returns a hash containing an array with two items populated from the baseline' do
          baseline_data = {
            names: [
              { pet: 'Mrs Bark' },
              { pet: 'Meow Meow Fuzzyface' }
            ]
          }
          response = get_response(baseline_data)
  
          expect(response).to eq(family: [ { petNames: 'Mrs Bark' }, { petNames: 'Meow Meow Fuzzyface' }])
        end
      end
    end
  end
end
