#Gets the source and destination paths to transfer the field given a schema
describe LocalAuthority::UseCase::GetSchemaCopyPaths do
  let(:template_gateway) { spy(find_by: spy(schema: template_schema)) }
  let(:use_case) { described_class.new(template_gateway: template_gateway).execute(type: '') }

  context 'simple schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            noise:
            {
              baselineKey: [:cats]
            }
          }
        }
      end
      it 'gets paths' do
        expect(use_case).to eq(paths: [{ to: [:noise], from: [:cats] }])
      end
    end

    context 'example 2' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            sounds:
            {
              baselineKey: [:dogs]
            }
          }
        }
      end
      it 'gets paths' do
        expect(use_case).to eq(paths: [{to: [:sounds], from: [:dogs]}])
      end
    end
  end

  context 'single level multi item schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            catNoise: {
              baselineKey: [:cats]
            },
            dogNoise: {
              baselineKey: [:dogs]
            },
            cowNoise: {
              baselineKey: [:cows]
            }
          }
        }
      end
      it 'gets paths' do
        expect(use_case).to eq(paths: [
          { to: [:catNoise], from: [:cats] },
          { to: [:dogNoise], from: [:dogs] },
          { to: [:cowNoise], from: [:cows] },
          ])
      end
    end
  end

  context 'single level mixed schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            catNoise: {
              baselineKey: [:cats]
            },
            dogNoise: {
            },
            cowNoise: {
              baselineKey: [:cows]
            }
          }
        }
      end
      it 'gets paths' do
        expect(use_case).to eq(paths: [
          { to: [:catNoise], from: [:cats] },
          { to: [:cowNoise], from: [:cows] },
          ])
      end
    end
  end

  context 'multilevel simple schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            cat: {
              type: 'object',
              properties: {
                breed: {
                  baselineKey: [:breed]
                }
              }
            }
          }
        }
      end

      it 'gets paths' do
        expect(use_case).to eq(paths: [
          { to: [:cat,:breed], from: [:breed] },
          ])
      end
    end
  end

  context 'multilevel more complex schema' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties: {
            cat: {
              type: 'object',
              properties: {
                parentA: {
                  type: 'object',
                  properties: {
                    breed: {
                      baselineKey: [:parentA]
                    }
                  }
                },
                parentB: {
                  type: 'object',
                  properties: {
                    breed: {
                      baselineKey: [:parentB]
                    }
                  }
                }
              }
            }
          }
        }
      end

      it 'gets paths' do
        expect(use_case).to eq(paths: [
          { to: [:cat,:parentA, :breed], from: [:parentA] },
          { to: [:cat,:parentB, :breed], from: [:parentB] },
          ])
      end
    end
  end

  context 'schema with top level array' do
    context 'example 1' do
      let(:template_schema) do
        {
          type: 'object',
          properties:
          {
            parents:
            {
              type: 'array',
              items: {
                type: 'object',
                properties:
                {
                  breed: {
                    baselineKey: [:breed]
                  }
                }
              }
            }
          }
        }
      end

      it 'gets paths' do
        expect(use_case).to eq(paths: [
          { to: [:parents,:breed], from: [:breed] },
          ])
      end
    end
  end
end