class CollaborationController < ApplicationController

  before_filter :find_participant_or_redirect

  def begin_chat
    @participant.status=("chat#{@participant.which_chat}_ready")
    @participant.save
    
    if !@participant.partner.here_or_further("chat#{@participant.which_chat}_ready")
      render 'wait' and return
    end    
    
    #if html request
    pairing = @participant.pairing
    pairing.chat_start = Time.now
    pairing.save

    #okay now chat!
    redirect_to :action => 'chat'
  end

  def chat
    @chat_length_sec = CHAT_LENGTH_CONSTANT
  
    @chat_start = @participant.pairing.chat_start
    @messages = @participant.pairing.messages.where("which_chat = ?", @participant.which_chat).order("created_at DESC")
    
  end

  def end_chat
    @participant.status= "chat#{@participant.which_chat}_complete"
    @participant.save

    redirect_to :controller => 'qualtrics', :action => 'to_qualtrics'
  end

  def quiz_results
    @participant.status = "quiz_finished"
    @participant.save
    
    wait_for_partner("quiz_finished")
    
    @next_step = {
      :controller => :collaboration, 
      :action => :begin_chat
    }
  end

  def money_decide
    #decide how much money to send, or wait for partner
    @starting_money = STARTING_MONEY_CONSTANT
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
      render 'wait' and return
    end
  end

end













