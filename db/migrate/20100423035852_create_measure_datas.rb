class CreateMeasureDatas < ActiveRecord::Migration
  def self.up
    create_table :measure_datas do |t|
      t.integer :user_id
      #t.references :kind, :polymorphic => true
      t.string :ruby_type
      t.text   :datas
      t.datetime :measured_at
      t.timestamps
    end
    add_index :measure_datas ,[:user_id,:ruby_type]
    add_index :measure_datas ,:user_id
    add_index :measure_datas ,:ruby_type
  end

  def self.down
    drop_table :measure_datas
  end
end
