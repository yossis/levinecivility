class CreatePairings < ActiveRecord::Migration
  def change
    create_table :pairings do |t|
      t.datetime :formed
      t.string :progress

      t.timestamps
    end
  end
end
