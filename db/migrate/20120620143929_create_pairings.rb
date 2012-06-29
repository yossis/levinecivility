class CreatePairings < ActiveRecord::Migration
  def change
    create_table :pairings do |t|
      t.datetime :formed

      t.timestamps
    end
  end
end
