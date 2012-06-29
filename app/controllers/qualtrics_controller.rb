class QualtricsController < ApplicationController

  #this should handle all interactions with qualtrics

  before_filter :find_participant_or_redirect, :except =>[:start, :no_participant, :participant_status]

  def start
    code = params[:participant_code]
    if code.nil?
      puts "Cant start without participant code"
      no_participant
    else
      status = Participant.get_status_by_code(code)
      case status
      when 'noexist'
        redirect_to :controller => 'participants', :action => 'create', :participant_code => params[:participant_code]
      when 'chat1_complete'
        redirect_to :controller => 'collaboration', :action => 'quiz_results'
      when 'chat2_complete'
        redirect_to :controller => 'collaboration', :action => 'money_decide'
      when 'money_sent'
        redirect_to :controller => 'collaboration', :action => 'money_results'
      when 'money_results_viewed'
        good_bye
      else
        #TODO hmmm how should I handle these other cases???
        #for now I only put cases that would come from qualtrics
        render :text => "qualtrics#start #{status}"
      end
    end
  end

  def to_qualtrics
    sid = QUALTRICS_SID_CONSTANT
    case @participant.status
    when 'chat1_complete'
      stage = 2
    when 'chat2_complete'
      stage = 3
    when 'money_sent'
      stage = 4
    when 'money_results_viewed'
      stage = 5
    else
      puts "Invalid status :#{@participant.status}: for redirect to qualtrics"
      stage = 99
    end
    redirect_to 'http://wharton.qualtrics.com/SE/?SID='+ sid +'&participant_code=' + @participant.code + '&stage=' + stage.to_s;
  end

  def no_participant
    @qualtrics_link = "http://wharton.qualtrics.com/SE/?SID=" + QUALTRICS_SID_CONSTANT
    render :amazon_turk_faux
  end
  
  def good_bye
    render :text => 'Good Bye'
  end

  #webservice
  def participant_status
    if params[:participant_code]
      status = Participant.get_status_by_code(params[:participant_code])
      render :json => {:status => status}
    else
      render :json => {:error => "Must supply participant code"}
    end
  end

end
