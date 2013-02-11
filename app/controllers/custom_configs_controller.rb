class CustomConfigsController < ApplicationController
  def update
    CustomConfig.hash.keys.each do |key|
      CustomConfig.update(key,params[key])  
    end
  render :text => "Updated #{CustomConfig.hash}"
  end

end
