class Message < Exportablee
  belongs_to :participant
  has_one :pairing, :through => :participant
  
end
