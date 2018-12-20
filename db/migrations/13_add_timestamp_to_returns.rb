Sequel.migration do
  change do
    alter_table(:returns) do
      add_column :timestamp, Integer, default: 0
    end
  end
end
