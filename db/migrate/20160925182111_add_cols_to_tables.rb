class AddColsToTables < ActiveRecord::Migration
  def change
    add_column :slideshows, :last_accessed, :datetime, :default => Date.today
    add_column :users, :admin, :boolean, :default => false
  end
end
