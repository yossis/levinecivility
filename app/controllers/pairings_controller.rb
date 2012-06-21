class PairingsController < ApplicationController

  #before_filter :before

  def create  
    participant = Participant.find(params[:participant_id])
    if participant.partner.nil?
      participant.establish_partner
    end
    if participant.partner.nil?
      render 'wait'
    else
      redirect_to :controller => :qualtrics, :action => :enter, :participant_code => participant.code
    end
  end

  def play
    pairing = Pairing.find(params[:id])
    if pairing.progress.nil?
      redirect_parameters = {
        :action => :chat1,
        :id => params[:id],
        :participant_id => params[:participant_id]
      }
    end
    redirect_to redirect_parameters
  end

  def chat1
    @pairing = Pairing.find(params[:id])
    @participant = Participant.find(params[:participant_id])
    @messages = @pairing.messages.order("created_at DESC")
    #chat for two minutes, then automatically stop and redirect back to qualtrics
  end

  def quiz_results
  end

  def chat2
  end

  def money_decide
  end

  def money_send
  end

  def money_results
  end

end
