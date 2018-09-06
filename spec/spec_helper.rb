require 'loader'
require 'pry'
require_relative 'database_context'
require_relative 'admin_context'

RSpec.configure do |config|
  database = DatabaseAdministrator::Postgres.new.fresh_database

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.before(:all) { @database = database }

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
