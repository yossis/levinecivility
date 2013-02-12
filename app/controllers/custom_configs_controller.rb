class CustomConfigsController < ApplicationController
  def update
    CustomConfig.hash.keys.each do |key|
      CustomConfig.update(key,params[key])  
    end
    flash[:update_conf] = "Updated #{CustomConfig.hash.inspect}"
    @confighash = CustomConfig.hash
    render 'admin/admin'
  end
end
