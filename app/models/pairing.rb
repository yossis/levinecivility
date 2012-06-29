class Pairing < ActiveRecord::Base
  has_many :participants
  has_many :messages, :through => :participants

  def self.text_export
    headerline = ""
    new.attributes.each do |key,value|
      headerline = "#{headerline}#{key}\t"
    end
    headerline = "#{headerline}\n"
    
    textfile = headerline    
    all.each do |item|
      textfile += item.to_csv
    end
    textfile
  end
    
  def to_csv
    line = ""
    attributes.each do|key,value|
      line = "#{line}#{value}\t"
    end
    line = "#{line}\n"
    line
  end

  def participant1
    participants.find_by_pairing_role(1)
  end
  
  def participant2
    participants.find_by_pairing_role(2)
  end

end
