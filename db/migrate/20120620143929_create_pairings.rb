class CreatePairings < ActiveRecord::Migration
  def change
    create_table :pairings do |t|
      t.datetime :formed
      t.datetime :chat_start

      t.timestamps
    end
  end
end
