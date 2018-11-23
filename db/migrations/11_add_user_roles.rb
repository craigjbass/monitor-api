# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table(:users) do
      add_column :role, String, default: 'Local Authority'
    end
  end

  down do
    alter_table(:users) do
      drop_column :role
    end
  end
end
