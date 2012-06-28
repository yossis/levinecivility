class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :code
      t.integer :pairing_id
      t.integer :pairing_role
      t.float :money_transfer
      t.datetime :joined
      t.datetime :last_contact
      t.string :status_data

      t.timestamps
    end
  end
end
