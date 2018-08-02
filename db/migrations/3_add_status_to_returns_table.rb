Sequel.migration do
  change do
    alter_table(:returns) do
      add_column :status, String
    end
  end
end
