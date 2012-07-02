class Participant < Exportable
  belongs_to :pairing
  has_many :messages
  
  #validates :money_transfer, :numericality => true, :on => :update
  validate :validate_money_transfer_within_limits, :on => :update

  def validate_money_transfer_within_limits
    unless money_transfer_within_limits?
      errors.add(:money_transfer, "not within limits")
    end
  end

  def money_transfer_within_limits?
    if money_transfer.nil?
      true
    elsif pairing_role == 1
      money_transfer<=STARTING_MONEY_CONSTANT       
    elsif pairing_role == 2
      money_transfer<=(partner.money_transfer*3)
    end
  end  
    
  @@possible_statuses = [
    'exists',
    'paired',
    'chat1_ready',
    'chat1_complete',
    'quiz_finished',
    'quiz_score_reported',
    'quiz_results_viewed',
    'chat2_ready',
    'chat2_complete',
    'money_sent',
    'money_results_viewed'
  ]
    
  def self.get_status_by_code(code)
    participant = Participant.find_by_code(code)
    if participant.nil?
      'noexist'
    else
      participant.status
    end
  end

  def status
    if pairing.nil?
      'exists'
    elsif status_data.nil?  
      'paired'
    else
      @@possible_statuses[status_data.to_i]
    end
  end
  
  def status=(new_status)
    self.status_data = @@possible_statuses.index(new_status)
  end
  
  def here_or_further(test_status)
    test_step = @@possible_statuses.index(test_status)
    my_step = @@possible_statuses.index(status)
    my_step >= test_step
  end

  def which_chat
    if here_or_further('chat1_complete')
      2
    else
      1
    end
  end
  
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

  def final_payout
    if money_transfer.nil? || partner.money_transfer.nil?
      return nil
    end
    original_money = STARTING_MONEY_CONSTANT
    if pairing_role == 1
      original_money - money_transfer + partner.money_transfer
    elsif pairing_role ==2
      partner.money_transfer*3 - money_transfer
    end
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





