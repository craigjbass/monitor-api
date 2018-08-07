# frozen_string_literal: true

xdescribe LocalAuthority::UseCase::PopulateReturnTemplate do
  let(:template_gateway_spy) { spy(find_by: template) }
  let(:use_case) { described_class.new(template_gateway: template_gateway_spy) }
  let(:response) { use_case.execute(type: project_type, data: baseline) }

  before { response }

  context 'example one' do
    let(:project_type) { 'meow' }

    context 'with matching baseline and template key' do
      let(:template) do
        LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
          p.layout = {
            cats: nil
          }
        end
      end
      let(:baseline) { { cats: 'meow' } }

      it 'fetches the template for the given type' do
        expect(template_gateway_spy).to(
          have_received(:find_by).with(type: 'meow')
        )
      end

      it 'will return populated data' do
        expect(response).to eq(populated_data: { cats: 'meow' })
      end
    end

    context 'with a baseline missing one top level template key' do
      let(:template) do
        LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
          p.layout = {
            doggos: nil,
            ducks: 'quack'
          }
        end
      end
      let(:baseline) { { doggos: 'woof' } }

      it 'will populate template with baseline with default template values' do
        expect(response).to eq(populated_data: { doggos: 'woof', ducks: 'quack' })
      end
    end

    context 'with field in baseline but not in template' do
      let(:template) do
        LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
          p.layout = {
            doggos: nil
          }
        end
      end
      let(:baseline) { { doggos: 'woof', ducks: 'quack' } }

      it 'will populate template with baseline with default template values' do
        expect(response).to eq(populated_data: { doggos: 'woof' })
      end
    end

    context 'with matching baseline and template nested hash' do
      let(:template) do
        LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
          p.layout = {
            doggos: nil,
            good_animals: {
              more_doggos: nil,
              less_cats: nil
            }
          }
        end
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
          expect(response).to eq(
            populated_data: {
              doggos: 'woof',
              good_animals: {
                more_doggos: 'more woof',
                less_cats: 'meow'
              }
            }
          )
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
          expect(response).to eq(
            populated_data: {
              doggos: 'woof',
              good_animals: {
                more_doggos: nil,
                less_cats: 'meow'
              }
            }
          )
        end
      end
    end
  end

  context 'example two' do
    let(:project_type) { 'woof' }

    context 'with matching baseline and template key' do
      let(:template) do
        LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
          p.layout = {
            dogs: nil
          }
        end
      end
      let(:baseline) { { dogs: 'woof' } }

      it 'fetches the template for the given type' do
        expect(template_gateway_spy).to(
          have_received(:find_by).with(type: 'woof')
        )
      end

      it 'will return populated data' do
        expect(response).to eq(populated_data: { dogs: 'woof' })
      end
    end

    context 'with a baseline missing one top level template key' do
      let(:template) do
        LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
          p.layout = {
            doggos: nil,
            cows: 'moo'
          }
        end
      end
      let(:baseline) { { doggos: 'woof' } }

      it 'will populate template with baseline with default template values' do
        expect(response).to eq(populated_data: { doggos: 'woof', cows: 'moo' })
      end
    end

    context 'with field in baseline but not in template' do
      let(:template) do
        LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
          p.layout = {
            cats: nil
          }
        end
      end
      let(:baseline) { { cats: 'meow', ducks: 'quack' } }

      it 'will populate template with baseline with default template values' do
        expect(response).to eq(populated_data: { cats: 'meow' })
      end
    end

    context 'with matching baseline and template nested hash' do
      let(:template) do
        LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
          p.layout = {
            cows: nil,
            good_animals: {
              more_cows: nil,
              chickens: nil
            }
          }
        end
      end

      context 'with all fields in baseline' do
        let(:baseline) do
          {
            cows: 'moo',
            good_animals: {
              more_cows: 'more moo',
              chickens: 'cluck'
            }
          }
        end

        it 'will override template data if keys match' do
          expect(response).to eq(
            populated_data: {
              cows: 'moo',
              good_animals: {
                more_cows: 'more moo',
                chickens: 'cluck'
              }
            }
          )
        end
      end

      context 'with fields missing from in baseline' do
        let(:baseline) do
          {
            cows: 'moo',
            good_animals: {
              chickens: 'cluck'
            }
          }
        end

        it 'will override template data if keys match' do
          expect(response).to eq(
            populated_data: {
              cows: 'moo',
              good_animals: {
                more_cows: nil,
                chickens: 'cluck'
              }
            }
          )
        end
      end
    end
  end
end
