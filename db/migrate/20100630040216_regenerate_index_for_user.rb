class RegenerateIndexForUser < ActiveRecord::Migration
  def self.up
    remove_index :users ,:api_key
    add_index :users,:api_key
  end

  def self.down
  end
end
