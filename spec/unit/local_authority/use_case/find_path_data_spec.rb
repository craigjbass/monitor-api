describe LocalAuthority::UseCase::FindPathData do

  let(:use_case) { described_class.new.execute(baseline_data, path) }

  context 'with simple paths' do
    context 'example 1' do
      let(:baseline_data) do
        { noises: { cat: 'meow' } }
      end

      let(:path) { [:noises, :cat] }
      it 'can find a simple path' do
        expect(use_case).to eq(found: 'meow')
      end
    end

    context 'example 2' do
      let(:baseline_data) do
        { sounds: { dog: 'woof' } }
      end

      let(:path) { [:sounds, :dog] }

      let(:use_case) { described_class.new.execute(baseline_data, path) }
      it 'can find a simple path' do
        expect(use_case).to eq(found: 'woof')
      end
    end
  end

  context 'with paths that include a single item array' do
    context 'example 1' do
      let(:baseline_data) do
        { noises: [{ cat: 'meow' }] }
      end
      let(:path) { [:noises, :cat] }

      it 'can find a relevent item for a single item array' do
        expect(use_case).to eq(found: ['meow'])
      end
    end

    context 'example 2' do
      let(:baseline_data) do
        { sounds: [{ dog: 'woof' }] }
      end
      let(:path) { [:sounds, :dog] }

      it 'can find a relevent item for a single item array' do
        expect(use_case).to eq(found: ['woof'])
      end
    end
  end

  context 'with paths that include a multi item array' do
    let(:baseline_data) do
      { noises: [{ cat: 'meow' }, { cat: 'nyan' }] }
    end
    let(:path) { [:noises, :cat] }

    it 'can find a relevent item for a single item array' do
      expect(use_case).to eq(found: ['meow','nyan'])
    end
  end

  context 'with paths that include a multi item array that contain somewhat complex hashes' do
    let(:baseline_data) do
      { noises: [{ cat: { type: 'tabby'} }, { cat: { type: 'tom'} }] }
    end
    let(:path) { [:noises, :cat, :type] }

    it 'can find a relevent item for a single item array' do
      expect(use_case).to eq(found: ['tabby','tom'])
    end
  end

  context 'hash in item array in hash in item array ' do
    let(:baseline_data) do
      {
        noises:
        [
          {
            cat:
            {
              parents:
              [
                {type: 'tabby'},
                {type: 'tom'}
              ]
            }
          },
          {
            cat:
            { parents:
              [
                {type: 'aegean'},
                {type: 'abyssinian'}
              ]
            }
          }
        ]
      }
    end
    let(:path) { [:noises, :cat, :parents, :type] }

    it 'can find a relevent item for a single item array' do
      expect(use_case).to eq(found: [['tabby','tom'],['aegean','abyssinian']])
    end
  end

  context 'realistic test' do
    let(:baseline_data) do
      {
        infrastructures: [
          {
            milestones: [
              {
                descriptionOfMilestone: "Milestone One"
              },
              {
                descriptionOfMilestone: "Milestone Two"
              }
            ]
          }
        ]
      }
    end
    let(:path) { [:infrastructures, :milestones, :descriptionOfMilestone] }

    it 'can find a relevent item for a single item array' do
      expect(use_case).to eq(found: [["Milestone One", "Milestone Two"]])
    end
  end
end
