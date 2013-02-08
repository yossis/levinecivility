class CreateCustomConfigs < ActiveRecord::Migration
  def change
    create_table :custom_configs do |t|
      t.string :name
      t.string :value
      t.timestamps
    end
    add_index :custom_configs, :name, :unique => true
  end
end
