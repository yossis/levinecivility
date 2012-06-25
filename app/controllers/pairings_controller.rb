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
        :action => :chat,
        :id => params[:id],
        :which_chat => 1,
        :participant_id => params[:participant_id],
        :participant_code => Participant.find(params[:participant_id]).code #TODO this is hella sloppy, fix it
      }
    elsif pairing.progress == 'chat1_finished'
      redirect_parameters = {
        :controller => :pairings, 
        :action => :quiz_results, 
        :id => params[:id],
        :participant_id => params[:participant_id], 
        :participant_code => Participant.find(params[:participant_id]).code
      }
      redirect_to redirect_parameters and return 
    elsif pairing.progress == 'chat2_finished'
      redirect_parameters = {
        :controller => :pairings, 
        :action => :money_decide, 
        :id => params[:id],
        :participant_id => params[:participant_id], 
        :participant_code => Participant.find(params[:participant_id]).code
      }
      redirect_to redirect_parameters and return
    end
  end

  def chat
    @pairing = Pairing.find(params[:id])
    @participant = Participant.find(params[:participant_id])
    @messages = @pairing.messages.order("created_at DESC")
    #chat for two minutes, then automatically stop and redirect back to qualtrics
  end

  def end_chat
    pairing = Pairing.find(params[:id])
    pairing.progress = "chat#{params[:which_chat]}_finished"
    pairing.save
    if params[:which_chat].to_i == 1
      stage = '2'
    elsif params[:which_chat].to_i == 2
      stage = '3'
    end
    #//window.location = 'http://wharton.qualtrics.com/SE/?SID=SV_8GEE97brucNde6w&stage=3&participant_code=' + participant_code;
    redirect_to 'http://wharton.qualtrics.com/SE/?SID=SV_8GEE97brucNde6w&stage='+ stage +'&participant_code=' + params[:participant_code];
  end

  def quiz_results
    @redirect_params_continue = {
      :controller => :pairings, 
      :action => :chat, 
      :id => params[:id], 
      :participant_id => params[:participant_id], 
      :participant_code => params[:participant_code],
      :which_chat => 2
    }
  end

  def money_decide
    #decide how much money to send, or wait for partner
    
  end

  def money_send
  end

  def money_results
  end

end
