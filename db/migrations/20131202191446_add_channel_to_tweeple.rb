Sequel.migration do
  up do
    add_column :tweeple, :channel, String
  end
  
  down do
    drop_column :tweeple, :channel
  end
end
