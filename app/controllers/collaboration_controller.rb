class CollaborationController < ApplicationController

  before_filter :find_participant_or_redirect

  def find_partner
  end

  #render instead of redirect
  #def wait
  #end

  def chat
    ready_status = "ready_for_chat_" + params[:which_chat].to_s
    @participant.status_data = ready_status
    @participant.save
    if @participant.partner.status_data != ready_status
      render 'wait'
    end
    @messages = @participant.pairing.messages.order("created_at DESC")
    #chat for two minutes, then automatically end
  end

  def end_chat
    @participant.status_data = "chat#{params[:which_chat]}_complete"
    @participant.save
    
    pairing = @participant.pairing
    pairing.status_data = "chat#{params[:which_chat]}_complete"
    pairing.save

    redirect_to :controller => 'qualtrics', :action => 'to_qualtrics'
  end

  def quiz_results
    @participant.status_data = "quiz_done"
    @participant.save
    
    ready_to_view = (@participant.partner.status_data == "quiz_done") || (@participant.partner.status_data == "ready_for_chat_2")
    if ! ready_to_view
      render 'wait'
    end
    
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
      if@participant.partner.status_data != "money_sent"
        render 'wait'
      else
        @money_from_partner = @participant.partner.money_transfer
      end
    end
  end

  def money_send
    @participant.money_transfer = params[:money_to_send]
    @participant.status_data = "money_sent"
    @participant.save
    redirect_to :controller => 'qualtrics', :action => 'to_qualtrics'
  end

  def money_results
    should_wait = (@participant.partner.status_data != 'money_sent') && (@participant.partner.status_data != 'money_results_viewed')
    if should_wait
      render 'wait'
    end
    @role = @participant.pairing_role
    pairing = @participant.pairing
    @first_transfer = pairing.participant1.money_transfer  
    @second_transfer = pairing.participant2.money_transfer
    @final_payout_role1 = pairing.participant1.final_payout
    @final_payout_role2 = pairing.participant2.final_payout    

    @next_step = {:controller => 'collaboration', :action => 'money_results_viewed'}

  end

  def money_results_viewed
    @participant.status_data = "results_viewed"
    @participant.save
    redirect_to :controller => 'qualtrics', :action => 'to_qualtrics'
  end

end













