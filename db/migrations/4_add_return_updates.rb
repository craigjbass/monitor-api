Sequel.migration do
  change do
    create_table :return_updates do
      primary_key :id, type: :Bignum
      column :return_id, :Bignum, index: true
      column :data, 'json'
    end
  end
end
