class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :participant_id
      t.integer :which_chat
      t.text :body

      t.timestamps
    end
  end
end
