class AddUserCloumn < ActiveRecord::Migration
  def self.up
    add_column :users, :api_key, :string, :limit => 40, :default => ""
    add_column :users, :type ,:string
    add_index :users, :api_key ,:unique=>true
  end
 
  def self.down
    remove_column :users, :api_key
    remove_column :users, :type
  end

end
