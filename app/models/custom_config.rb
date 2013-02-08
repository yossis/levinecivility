class CustomConfig < ActiveRecord::Base

  def self.hash
    h={}
    self.all.each {|c| h[c.name.to_sym]=c.value.to_i}
    h
  end


end
