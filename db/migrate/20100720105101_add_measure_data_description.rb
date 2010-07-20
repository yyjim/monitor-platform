class AddMeasureDataDescription < ActiveRecord::Migration
  def self.up
    add_column :measure_datas, :description ,:text
  end

  def self.down
    remove_column :measure_datas, :description
  end
end
