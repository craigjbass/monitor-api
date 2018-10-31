# frozen_string_literal: true

describe 'Migration 8' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 7)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 8)
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
        summary: { noOfHousingSites: 15, totalArea: 12, hifFundingAmount: 10_000 },
        infrastructures: [
          {
            landOwnership: {
              howManySitesToAcquire: 10
            }
          }
        ],
        outputsForecast: {
          totalUnits: 5
        }
      }
    end

    let(:migrated_project_data) { database[:projects].all.first[:data] }

    before do
      create_project(type: 'hif', data: baseline_data)

      synchronize_to_migrated_version
    end

    it 'Converts the sites to acquire to a string' do
      sites_to_acquire = migrated_project_data['infrastructures'][0]['landOwnership']['howManySitesToAcquire']

      expect(sites_to_acquire).to eq('10')
    end

    it 'Migrates the number of housing sites to a string' do
      number_of_housing_sites = migrated_project_data['summary']['noOfHousingSites']

      expect(number_of_housing_sites).to eq('15')
    end

    it 'Migrates the total area to a string' do
      total_area = migrated_project_data['summary']['totalArea']

      expect(total_area).to eq('12')
    end

    it 'Migrates the HIF funding amount to a string' do
      hif_funding_amount = migrated_project_data['summary']['hifFundingAmount']

      expect(hif_funding_amount).to eq('10000')
    end

    it 'Migrates the outputs forecast total units to a string' do
      total_units = migrated_project_data['outputsForecast']['totalUnits']

      expect(total_units).to eq('5')
    end
  end

  context 'Example two' do
    let(:project_one_data) do
      {
        summary: {
          noOfHousingSites: 1,
          totalArea: 101,
          hifFundingAmount: 20_000
        },
        outputsForecast: {
          totalUnits: 6
        },
        infrastructures: [
          {
            landOwnership: {
              howManySitesToAcquire: 50
            }
          }
        ]
      }
    end

    let(:project_two_data) do
      {
        summary: {
          noOfHousingSites: 2,
          totalArea: 102,
          hifFundingAmount: 30_000
        },
        outputsForecast: {
          totalUnits: 7
        },
        infrastructures: [
          {
            landOwnership: {
              howManySitesToAcquire: 100
            }
          },
          {
            landOwnership: {
              howManySitesToAcquire: 150
            }
          }
        ]
      }
    end

    let(:project_one_id) { create_project(type: 'hif', data: project_one_data) }
    let(:project_two_id) { create_project(type: 'hif', data: project_two_data) }

    let(:migrated_project_one_data) { database[:projects].where(id: project_one_id).all.first[:data] }
    let(:migrated_project_two_data) { database[:projects].where(id: project_two_id).all.first[:data] }

    before do
      project_one_id
      project_two_id
      synchronize_to_migrated_version
    end

    it 'Converts the how many sites to acquire to a string' do
      sites_to_acquire = migrated_project_one_data['infrastructures'][0]['landOwnership']['howManySitesToAcquire']
      expect(sites_to_acquire).to eq('50')

      sites_to_acquire = migrated_project_two_data['infrastructures'][0]['landOwnership']['howManySitesToAcquire']
      expect(sites_to_acquire).to eq('100')

      sites_to_acquire = migrated_project_two_data['infrastructures'][1]['landOwnership']['howManySitesToAcquire']
      expect(sites_to_acquire).to eq('150')
    end

    it 'Converts the number of housing sites to a string' do
      number_of_housing_sites = migrated_project_one_data['summary']['noOfHousingSites']
      expect(number_of_housing_sites).to eq('1')

      number_of_housing_sites = migrated_project_two_data['summary']['noOfHousingSites']
      expect(number_of_housing_sites).to eq('2')
    end

    it 'Migrates the total area to a string' do
      total_area = migrated_project_one_data['summary']['totalArea']
      expect(total_area).to eq('101')

      total_area = migrated_project_two_data['summary']['totalArea']
      expect(total_area).to eq('102')
    end

    it 'Migrates the HIF funding amount to a string' do
      hif_funding_amount = migrated_project_one_data['summary']['hifFundingAmount']
      expect(hif_funding_amount).to eq('20000')

      hif_funding_amount = migrated_project_two_data['summary']['hifFundingAmount']
      expect(hif_funding_amount).to eq('30000')
    end

    it 'Migrates the outputs forecast total units to a string' do
      total_units = migrated_project_one_data['outputsForecast']['totalUnits']
      expect(total_units).to eq('6')

      total_units = migrated_project_two_data['outputsForecast']['totalUnits']
      expect(total_units).to eq('7')
    end
  end
end
