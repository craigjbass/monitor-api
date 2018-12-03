Sequel.migration do
  change do
    alter_table(:projects) do
      add_column :timestamp, Integer, default: 0
    end
  end
end