class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def find_participant_or_redirect
    if params[:participant_code]
      participant = Participant.find_by_code(params[:participant_code])
      if participant.nil?
        message = "Invalid participant code"
        puts message
        render :text => message
      else
        session[:participant_id] = participant.id
      end
    end

    if session[:participant_id]
      participant = Participant.find(session[:participant_id])
      if participant.nil?
        message = "Invalid participant id in session"
        puts message
        render :text => message
      else
        @participant = participant
        record_last_contact
      end
    else
      redirect_to :controller => :qualtrics, :action => :no_participant
    end

  end
  
  def record_last_contact
    @participant.last_contact = DateTime.now
    @participant.save
    
  end
  
end

