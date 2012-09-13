class Exportable < ActiveRecord::Base

  self.abstract_class = true

  def self.text_export
    headerline = ""
    headerline = new.attributes.keys.join(",") + "\n"
    
    textfile = headerline    
    all.each do |item|
      textfile += item.attributes.values.join(",") + "\n"
    end
    textfile
  end
    
end
