Sequel.migration do
  change do
    create_table :users do
      primary_key :id, type: :Bignum
      column :email, :text, index: true
      column :projects, 'int[]'
    end
  end
end
