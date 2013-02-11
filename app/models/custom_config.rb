class CustomConfig < ActiveRecord::Base

  public :write_attribute

  def self.hash
    h={}
    self.all.each {|c| h[c.name.to_sym]=c.value.to_i}
    h
  end

  def self.get(name)
    CustomConfig.find_by_name(name).value
    ##puts to screen if not found
  end

  def self.update(name, value)
    config_param = CustomConfig.find_by_name(name)
    config_param.value = value
    config_param.save
    ##puts to screen if not found
  end

end
