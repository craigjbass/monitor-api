Sequel.migration do
  change do
    alter_table(:projects) do
      add_column :status, String, default: 'Submitted'
    end
  end
end
