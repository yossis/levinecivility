class CollaborationController < ApplicationController

  before_filter :find_participant_or_redirect

  def chat
    wait_for_partner('paired')
    @messages = @participant.pairing.messages.order("created_at DESC")
    #use javascript to end after two minutes
  end

  def end_chat
    @participant.status= "chat#{params[:which_chat]}_complete"
    @participant.save

    redirect_to :controller => 'qualtrics', :action => 'to_qualtrics'
  end

  def quiz_results
    @participant.status = "quiz_finished"
    @participant.save
    
    wait_for_partner("quiz_finished")
    
    @next_step = {
      :controller => :collaboration, 
      :action => :chat, 
      :which_chat => 2
    }
  end

  def money_decide
    #decide how much money to send, or wait for partner
    @starting_money = 5
    @is_role1 = (@participant.pairing_role == 1)
    @is_role2 = (@participant.pairing_role == 2)
    if @participant.pairing_role == 2 
      if@participant.partner.status != "money_sent"
        render 'wait'
      else
        @money_from_partner = @participant.partner.money_transfer
      end
    end
  end

  def money_send
    @participant.money_transfer = params[:money_to_send]
    @participant.status = "money_sent"
    @participant.save
    redirect_to :controller => 'qualtrics', :action => 'to_qualtrics'
  end

  def money_results
    wait_for_partner('money_sent')
    
    @role = @participant.pairing_role
    pairing = @participant.pairing
    @first_transfer = pairing.participant1.money_transfer  
    @second_transfer = pairing.participant2.money_transfer
    @final_payout_role1 = pairing.participant1.final_payout
    @final_payout_role2 = pairing.participant2.final_payout    

    @next_step = {:controller => 'collaboration', :action => 'money_results_viewed'}

  end

  def money_results_viewed
    @participant.status = "money_results_viewed"
    @participant.save
    redirect_to :controller => 'qualtrics', :action => 'to_qualtrics'
  end

  private
  
  def wait_for_partner(target_status)
    if !@participant.partner.here_or_further(target_status)
      render 'wait'
    end
  end

end













