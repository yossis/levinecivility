class Pairing < Exportable
  has_many :participants
  has_many :messages, :through => :participants

  def participant1
    participants.find_by_pairing_role(1)
  end
  
  def participant2
    participants.find_by_pairing_role(2)
  end

end
