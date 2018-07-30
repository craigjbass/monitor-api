Sequel.migration do
  change do
    create_table :returns do
      primary_key :id, type: :Bignum
      column :project_id, :Bignum, index: true
      column :data, 'json'
    end
  end
end
