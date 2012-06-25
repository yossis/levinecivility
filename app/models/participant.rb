class Participant < ActiveRecord::Base
  belongs_to :pairing
  has_many :messages
  
  
  def self.find_or_create_by_code(code)
    participant = Participant.find_by_code(code)
    if participant.nil?
      participant = Participant.create(:code => code, :joined => DateTime.now)
    end
    participant
  end

  def establish_partner
    #make strict assumption that any pairing has exactly two
    if partner 
      partner
    else
      if potential_partners.first && pair_with(potential_partners.first)
        partner
      else
        nil
      end
    end
  end
  
  def partner
    #making the assumption that a pairing will have EXACTLY two partners
    unless pairing.nil?
      pairing.participants.where("id <> ?", id).first
    else
      nil
    end
  end
  
  def is_paired
    ! pairing_id.nil?
  end  

  
  private

  def pair_with(partner)
  
    #check that partner and self aren't paired
    if self.pairing.nil? && partner.pairing.nil?
      new_pairing_id = Pairing.create(:formed => DateTime.now).id  
      self.pairing_id = new_pairing_id
      self.pairing_role = 1
      self.save
      partner.pairing_id = new_pairing_id
      partner.pairing_role = 2
      partner.save
      true
    else
      #should I have some sort of error here?? probably
      puts 'Unable to pair participants who already belong to a pairing'
      false
    end
  end
  
  def potential_partners
    #get list of potential partners ordered by preference (join time or last checkin)
    puts "Participant #{id} is looking for partners"
    self.class.order("joined ASC").find_all{|item| (!item.is_paired) && (item.id!=self.id)}
  end

  
end





