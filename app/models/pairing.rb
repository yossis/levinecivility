class Pairing < ActiveRecord::Base
  has_many :participants
  has_many :messages, :through => :participants

  def status
    status_data
  end

  def participant1
    participants.find_by_pairing_role(1)
  end
  
  def participant2
    participants.find_by_pairing_role(2)
  end

end
