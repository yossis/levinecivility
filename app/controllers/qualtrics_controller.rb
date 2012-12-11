class QualtricsController < ApplicationController

  #this should handle all interactions with qualtrics

  before_filter :find_participant_or_redirect, :except =>[:start, :no_participant, :participant_status, :report_score]

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
      when 'chat1_complete', 'quiz_score_reported'
        redirect_to :controller => 'collaboration', :action => 'quiz_results'
      when 'chat2_complete'
        redirect_to :controller => 'collaboration', :action => 'money_decide'
      when 'money_sent'
        redirect_to :controller => 'collaboration', :action => 'money_results'
      when 'money_results_viewed'
        good_bye
      when 'timed_out'
        timed_out
      when 'abandoned'
        abandoned
      when 'no_partners'
        no_partners
      else
        #TODO hmmm how should I handle these other cases???
        #for now I only put cases that would come from qualtrics
        render :text => "ERROR - status #{status} not recognized"
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
  
  def encode_payout(x)
    a, b, c = 7, 19, 31
    (x+b+rand(b)*c)*a
  end
  private :encode_payout

  def good_bye
    @participant = Participant.find_by_code(params[:participant_code])
    @payout_code = 'LC' + encode_payout(@participant.final_payout.round).to_s
#    @payout_code = 'LC' + encode_payout(8).to_s
    puts @participant.inspect
    render :text => "You are finished.<br/>  Amazon Turk payout code:#{@payout_code}"
  end
  
  def timed_out
    render :text => 'Timed Out'
  end

  #webservices
  def report_score
    if params[:participant_code] && params[:score]
      @participant = Participant.find_by_code(params[:participant_code])
      @participant.quiz_score = params[:score]
      @participant.status = 'quiz_score_reported'
      @participant.save
      render :json => {:status => 'success'}
    else
      render :json => {:status => "ERROR - Must supply participant code and score"}
    end
  end

  def participant_status
    if params[:participant_code]
      status = Participant.get_status_by_code(params[:participant_code])
      render :json => {:status => status}
    else
      render :json => {:error => "Must supply participant code"}
    end
  end

end
