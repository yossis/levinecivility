class CreateCustomConfigs < ActiveRecord::Migration

  def up
    create_table :custom_configs do |t|
      t.string :name
      t.string :value
      t.timestamps
    end
    add_index :custom_configs, :name, :unique => true

    if Rails.env == "production"
      CustomConfig.create(:name => "timeout_constant", :value => "300")
      CustomConfig.create(:name => "waitforpartner_timeout_constant", :value => "1200")
      CustomConfig.create(:name => "starting_money_constant", :value => "10")
      CustomConfig.create(:name => "chat_length_constant", :value => "120")
    else #probably development
      CustomConfig.create(:name => "timeout_constant", :value => "60")
      CustomConfig.create(:name => "waitforpartner_timeout_constant", :value => "120")
      CustomConfig.create(:name => "starting_money_constant", :value => "10")
      CustomConfig.create(:name => "chat_length_constant", :value => "30") 
    end
  end
  
  def down
    remove_index :custom_configs, :name => :index_custom_configs_on_name
    drop_table :custom_configs
  end
    
end






