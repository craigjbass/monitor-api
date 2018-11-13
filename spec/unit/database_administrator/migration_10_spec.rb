# frozen_string_literal: true

describe 'Migration 10' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 9)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 10)
  end

  def create_project(type:, data:)
    database[:projects].insert(
      type: type,
      data: Sequel.pg_json(data)
    )
  end

  let(:migrator) { ::Migrator.new }

  before { synchronize_to_non_migrated_version }

  context 'Example one' do
    let(:baseline_data) do
      {
        summary: {
          projectName: 'cats'
        }
      }
    end

    let(:migrated_project_name) { database[:projects].all.first[:name] }

    before do
      create_project(type: 'hif', data: baseline_data)

      synchronize_to_migrated_version
    end

    it 'Converts the sites to acquire to a string' do
      expect(migrated_project_name).to eq('cats')
    end
  end

  context 'Example two' do
    let(:baseline_data) do
      {
        summary: {
          projectName: 'dogs'
        }
      }
    end

    let(:migrated_project_name) { database[:projects].all.first[:name] }

    before do
      create_project(type: 'hif', data: baseline_data)

      synchronize_to_migrated_version
    end

    it 'Converts the sites to acquire to a string' do
      expect(migrated_project_name).to eq('dogs')
    end
  end
end
