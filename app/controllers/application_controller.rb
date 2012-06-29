class ApplicationController < ActionController::Base
  protect_from_forgery
  
  if Rails.env == 'production'
    QUALTRICS_SID_CONSTANT = 'SV_3WzzOUymYH3CGb2'
  else
    QUALTRICS_SID_CONSTANT = 'SV_8GEE97brucNde6w'
  end
  
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
      end
    else
      redirect_to :controller => :qualtrics, :action => :no_participant
    end

  end
end

