class CreatePairings < ActiveRecord::Migration
  def change
    create_table :pairings do |t|
      t.datetime :formed
      t.string :status_data

      t.timestamps
    end
  end
end
