# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Submitting a completed draft project' do
  include_context 'dependency factory'
  context 'Whilst status is LA Draft' do
    it 'Changes the status to submitted' do
      submitted_project = test_setup('la')

      expect(submitted_project[:status]).to eq('Submitted')
    end
  end

  context 'Whilst status is Draft' do
    it 'Changes the status to LA Draft' do
      submitted_project = test_setup('draft')

      expect(submitted_project[:status]).to eq('LA Draft')
    end
  end

  private

  def test_setup(status)
    project_baseline = {
      summary: {
        project_name: '',
        description: '',
        lead_authority: ''
      },
      infrastructure: {
        type: '',
        description: '',
        completion_date: '',
        planning: {
          submission_estimated: ''
        }
      },
      financial: {
        total_amount_estimated: ''
      }
    }
    response = get_use_case(:create_new_project).execute(
      name: 'cat project', type: 'hif', baseline: project_baseline
    )
    if status == 'la'
      2.times { get_use_case(:submit_project).execute(project_id: response[:id]) }
    elsif status == 'draft'
      get_use_case(:submit_project).execute(project_id: response[:id])
    end
    return get_use_case(:find_project).execute(id: response[:id])
  end
end
