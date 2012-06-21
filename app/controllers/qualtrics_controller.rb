class QualtricsController < ApplicationController

  def enter
    ##THIS IS VERY SIMILAR TO ROUTING
    if params[:participant_code].nil?
     puts "Participant Code was NIL"
     redirect_parameters = {
       :controller => :qualtrics,
       :action => :amazon_turk_faux
     }
    elsif Participant.find_by_code(params[:participant_code]).nil?
      #create participant
     redirect_parameters = {
       :controller => :participants,
       :action => :create,
       :participant_code => params[:participant_code]
     }
    elsif Participant.find_by_code(params[:participant_code]).pairing.nil?
      #redirect to pairing create
      redirect_parameters = {
        :controller => :pairings,
        :action => :create,
        :participant_id => Participant.find_by_code(params[:participant_code]).id
      }      
    else
      redirect_parameters = {
        :controller => :pairings,
        :action => :play,
        :id => Participant.find_by_code(params[:participant_code]).pairing.id,
        :participant_id => Participant.find_by_code(params[:participant_code]).id
      } 
    end
    redirect_to redirect_parameters
  end

  def amazon_turk_faux
  end

end
