class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :name
      t.text :description
      t.integer :other_id
      t.datetime :finish

      t.timestamps
    end
  end
end
