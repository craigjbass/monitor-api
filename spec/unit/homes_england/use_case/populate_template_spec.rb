# frozen_string_literal: true

describe HomesEngland::UseCase::PopulateTemplate do
  let(:template) {HomesEngland::Domain::Template.new(layout: {})}
  let(:template_gateway) {double(get_template: template)}
  let(:use_case) {described_class.new(template_gateway: template_gateway)}
  let(:response) do
    use_case.execute(type: type, baseline: baseline)
  end
  let(:baseline) {{}}

  before {response}

  context 'example one' do
    let(:type) {'hif'}

    it 'will find template of given type' do
      expect(template_gateway).to have_received(:get_template).with(type: 'hif')
    end

    context 'with matching baseline and template key' do
      let(:template) do
        HomesEngland::Domain::Template.new(
          layout: {
            cats: nil
          }
        )
      end
      let(:baseline) {{cats: 'meow'}}

      it 'will return baseline data' do
        expect(response).to eq(populated_data: {cats: 'meow'})
      end
    end

    context 'with a baseline missing one top level template key' do
      let(:template) do
        HomesEngland::Domain::Template.new(
          layout: {
            doggos: nil,
            ducks: 'quack'
          }
        )
      end
      let(:baseline) {{doggos: 'woof'}}

      it 'will populate template with baseline with default template values' do
        expect(response).to eq(populated_data: {doggos: 'woof', ducks: 'quack'})
      end
    end

    context 'with field in baseline but not in template' do
      let(:template) do
        HomesEngland::Domain::Template.new(
          layout: {
            doggos: nil
          }
        )
      end
      let(:baseline) {{doggos: 'woof', ducks: 'quack'}}

      it 'will populate template with baseline with default template values' do
        expect(response).to eq(populated_data: {doggos: 'woof'})
      end
    end

    context 'with matching baseline and template nested hash' do
      let(:template) do
        HomesEngland::Domain::Template.new(
          layout: {
            doggos: nil,
            good_animals: {
              more_doggos: nil,
              less_cats: nil
            }
          }
        )
      end
      context 'with all fields in baseline' do
        let(:baseline) do
          {
            doggos: 'woof',
            good_animals: {
              more_doggos: 'more woof',
              less_cats: 'meow'
            }
          }
        end

        it 'will override template data if keys match' do
          expect(response).to eq(populated_data: {
            doggos: 'woof',
            good_animals: {
              more_doggos: 'more woof',
              less_cats: 'meow'
            }
          })
        end
      end


      context 'with fields missing from in baseline' do
        let(:baseline) do
          {
            doggos: 'woof',
            good_animals: {
              less_cats: 'meow'
            }
          }
        end

        it 'will override template data if keys match' do
          expect(response).to eq(populated_data: {
            doggos: 'woof',
            good_animals: {
              more_doggos: nil,
              less_cats: 'meow'
            }
          })
        end
      end
    end
  end

  context 'example two' do
    let(:type) {'abc'}

    it 'will find template of given type' do
      expect(template_gateway).to have_received(:get_template).with(type: 'abc')
    end

    context 'with matching baseline and template key' do
      let(:template) do
        HomesEngland::Domain::Template.new(
          layout: {
            doggos: nil
          }
        )
      end
      let(:baseline) {{doggos: 'woof'}}

      it 'will return baseline data' do
        expect(response).to eq(populated_data: {doggos: 'woof'})
      end
    end

    context 'with a baseline missing one top level template key' do
      let(:template) do
        HomesEngland::Domain::Template.new(
          layout: {
            doggos: nil,
            cows: 'moo'
          }
        )
      end
      let(:baseline) {{doggos: 'woof'}}

      it 'will populate template with baseline with default template values' do
        expect(response).to eq(populated_data: {doggos: 'woof', cows: 'moo'})
      end
    end

    context 'with field in baseline but not in template' do
      let(:template) do
        HomesEngland::Domain::Template.new(
          layout: {
            doggos: nil
          }
        )
      end
      let(:baseline) {{doggos: 'woof', cows: 'moo'}}

      it 'will populate template with baseline with default template values' do
        expect(response).to eq(populated_data: {doggos: 'woof'})
      end
    end

    context 'with matching baseline and template nested hash' do
      let(:template) do
        HomesEngland::Domain::Template.new(
          layout: {
            cows: nil,
            more_animals: {
              cats: nil,
              dogs: nil
            }
          }
        )
      end
      context 'with all fields in baseline' do
        let(:baseline) do
          {
            cows: 'moo',
            more_animals: {
              cats: 'meow',
              dogs: 'woof'
            }
          }
        end

        it 'will override template data if keys match' do
          expect(response).to eq(populated_data: {
            cows: 'moo',
            more_animals: {
              cats: 'meow',
              dogs: 'woof'
            }
          })
        end
      end


      context 'with fields missing from in baseline' do
        let(:baseline) do
          {
            cows: 'moo',
            more_animals: {
              cats: 'meow'
            }
          }
        end

        it 'will override template data if keys match' do
          expect(response).to eq(populated_data: {
            cows: 'moo',
            more_animals: {
              cats: 'meow',
              dogs: nil
            }
          })
        end
      end
    end
  end
end
