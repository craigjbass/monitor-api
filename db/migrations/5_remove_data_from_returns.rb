Sequel.migration do
  up do
    alter_table(:returns) do
      drop_column :data
    end
  end

  down do
    alter_table(:returns) do
      add_column :data, 'json'
    end
  end
end
