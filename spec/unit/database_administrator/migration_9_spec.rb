# frozen_string_literal: true

describe 'Migration 9' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 8)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 9)
  end

  let(:migrator) { ::Migrator.new }

  before { synchronize_to_non_migrated_version }

  context 'Given a HIF project' do
    let(:project_id) { database[:projects].insert(type: 'hif') }
    let(:return_id) { database[:returns].insert(project_id: project_id) }

    before do
      project_id
      return_id
    end

    context 'Given a single funding package' do
      before do
        database[:return_updates].insert(return_id: return_id, data: Sequel.pg_json(return_data))
        synchronize_to_migrated_version
      end

      context 'Example one' do
        let(:return_data) do
          {
            fundingPackages: [
              {
                hifSpend: {
                  baseline: '10000'
                },
                fundingStack: {
                  totalCost: {
                    baseline: '20000'
                  },
                  fundedThroughHIF: 'No',
                  descriptionOfFundingStack: 'Funding stack description',
                  public: { baseline: '5000' },
                  private: { baseline: '5000' }
                }
              }
            ]
          }
        end
        let(:expected_migrated_funding_package) do
          {
            'fundingStack' => {
              'hifSpend' => {
                'baseline' => '10000'
              },
              'totalCost' => {
                'baseline' => '20000'
              },
              'fundedThroughHIF' => 'No',
              'descriptionOfFundingStack' => 'Funding stack description',
              'public' => { 'baseline' => '5000' },
              'private' => { 'baseline' => '5000' }
            }
          }
        end

        it 'Merges the funding package sections into one' do
          migrated_return = database[:return_updates].all.first[:data]

          expect(migrated_return['fundingPackages'].first).to eq(expected_migrated_funding_package)
        end
      end

      context 'Example two' do
        let(:return_data) do
          {
            fundingPackages: [
              {
                hifSpend: {
                  baseline: '20000'
                },
                fundingStack: {
                  totalCost: {
                    baseline: '30000'
                  },
                  fundedThroughHIF: 'Yes'
                }
              }
            ]
          }
        end

        let(:expected_migrated_funding_package) do
          {
            'fundingStack' => {
              'hifSpend' => {
                'baseline' => '20000'
              },
              'totalCost' => {
                'baseline' => '30000'
              },
              'fundedThroughHIF' => 'Yes'
            }
          }
        end

        it 'Merges the funding package sections into one' do
          migrated_return = database[:return_updates].all.first[:data]

          expect(migrated_return['fundingPackages'].first).to eq(expected_migrated_funding_package)
        end
      end
    end

    context 'Given multiple funding packages' do
      it 'Merges the funding package sections into one' do
        return_data = {
          fundingPackages: [
            {
              hifSpend: {
                baseline: '20000'
              },
              fundingStack: {
                totalCost: {
                  baseline: '30000'
                },
                fundedThroughHIF: 'Yes'
              }
            },
            {
              hifSpend: {
                baseline: '40000'
              },
              fundingStack: {
                totalCost: {
                  baseline: '60000'
                },
                fundedThroughHIF: 'Yes'
              }
            }
          ]
        }

        database[:return_updates].insert(return_id: return_id, data: Sequel.pg_json(return_data))
        synchronize_to_migrated_version

        migrated_return = database[:return_updates].all.first[:data]

        expected_migrated_return_data = {
          'fundingPackages' => [
            {
              'fundingStack' => {
                'hifSpend' => {
                  'baseline' => '20000'
                },
                'totalCost' => {
                  'baseline' => '30000'
                },
                'fundedThroughHIF' => 'Yes'
              }
            },
            {
              'fundingStack' => {
                'hifSpend' => {
                  'baseline' => '40000'
                },
                'totalCost' => {
                  'baseline' => '60000'
                },
                'fundedThroughHIF' => 'Yes'
              }
            }
          ]
        }

        expect(migrated_return).to eq(expected_migrated_return_data)
      end
    end

    context 'Given multiple return updates' do
      let(:return_one_data) do
        {
          fundingPackages: [
            {
              hifSpend: {
                baseline: '10000'
              },
              fundingStack: {
                totalCost: {
                  baseline: '20000'
                },
                fundedThroughHIF: 'No',
                descriptionOfFundingStack: 'Funding stack description',
                public: { baseline: '5000' },
                private: { baseline: '5000' }
              }
            }
          ]
        }
      end

      let(:return_two_data) do
        {
          fundingPackages: [
            {
              hifSpend: {
                baseline: '50000'
              },
              fundingStack: {
                totalCost: {
                  baseline: '60000'
                },
                fundedThroughHIF: 'Yes'
              }
            }
          ]
        }
      end

      let(:expected_migrated_data_one) do
        {
          'fundingPackages' => [
            {
              'fundingStack' => {
                'hifSpend' => {
                  'baseline' => '10000'
                },
                'totalCost' => {
                  'baseline' => '20000'
                },
                'fundedThroughHIF' => 'No',
                'descriptionOfFundingStack' => 'Funding stack description',
                'public' => { 'baseline' => '5000' },
                'private' => { 'baseline' => '5000' }
              }
            }
          ]
        }
      end

      let(:expected_migrated_data_two) do
        {
          'fundingPackages' => [
            {
              'fundingStack' => {
                'hifSpend' => {
                  'baseline' => '50000'
                },
                'totalCost' => {
                  'baseline' => '60000'
                },
                'fundedThroughHIF' => 'Yes'
              }
            }
          ]
        }
      end

      it 'Merges the data of both returns correctly' do
        return_one_id = database[:return_updates].insert(return_id: return_id, data: Sequel.pg_json(return_one_data))
        return_two_id = database[:return_updates].insert(return_id: return_id, data: Sequel.pg_json(return_two_data))
        synchronize_to_migrated_version

        migrated_return_updates = database[:return_updates].all

        migrated_return_one = migrated_return_updates.find { |r| r[:id] == return_one_id }
        migrated_return_two = migrated_return_updates.find { |r| r[:id] == return_two_id }

        expect(migrated_return_one[:data]).to eq(expected_migrated_data_one)
        expect(migrated_return_two[:data]).to eq(expected_migrated_data_two)
      end
    end
  end

  context 'Given a non-HIF project' do
    let(:return_data) do
      {
        'fundingPackages' => [
          {
            'hifSpend' => {
              'baseline' => '10000'
            },
            'fundingStack' => {
              'totalCost' => {
                'baseline' => '20000'
              },
              'fundedThroughHIF' => 'No',
              'descriptionOfFundingStack' => 'Funding stack description',
              'public' => { 'baseline' => '5000' },
              'private' => { 'baseline' => '5000' }
            }
          }
        ]
      }
    end

    it 'Does not migrate the data' do
      project_id = database[:projects].insert(type: 'ac')
      return_id = database[:returns].insert(project_id: project_id)
      database[:return_updates].insert(return_id: return_id, data: Sequel.pg_json(return_data))

      synchronize_to_migrated_version

      migrated_return = database[:return_updates].all.last

      expect(migrated_return[:data]).to eq(return_data)
    end
  end
end
