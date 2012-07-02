class Message < Exportable
  belongs_to :participant
  has_one :pairing, :through => :participant
  
end
