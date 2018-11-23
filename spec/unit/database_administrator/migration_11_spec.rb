# frozen_string_literal: true

describe 'Migration 11' do
  include_context 'with database'

  def synchronize_to_non_migrated_version
    migrator.migrate_to(database, 10)
  end

  def synchronize_to_migrated_version
    migrator.migrate_to(database, 11)
  end

  def create_user(email:)
    database[:users].insert(
      email: email
    )
  end

  let(:migrator) { ::Migrator.new }

  let(:migrated_user_role) { database[:users].all.first[:role] }

  before { synchronize_to_non_migrated_version }

  context 'Example one' do
    before do
      create_user(email: 'cat@cat.cat')

      synchronize_to_migrated_version
    end

    it 'Converts the sites to acquire to a string' do
      expect(migrated_user_role).to eq('Local Authority')
    end
  end

  context 'Example two' do
    before do
      create_user(email: 'dog@dog.dog')

      synchronize_to_migrated_version
    end

    it 'Converts the sites to acquire to a string' do
      expect(migrated_user_role).to eq('Local Authority')
    end
  end
end
