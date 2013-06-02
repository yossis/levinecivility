class QualtricsController < ApplicationController

  #this should handle all interactions with qualtrics

  before_filter :find_participant_or_redirect, :except =>[:start, :no_participant, :participant_status, :report_score]

  def start
    participant_code = params[:participant_code]
    survey_code = params[:survey_code]
    if participant_code.nil? || survey_code.nil?
      puts "Cant start without participant code and survey code"
      no_participant
    else
      status = Participant.get_status_by_code(participant_code)
      session[:participant_code] = params[:participant_code].match(/\s/)  ##this is also set in participants#create
      session[:survey_code] = params[:survey_code]
      case status
      when 'noexist'
        redirect_to :controller => 'participants', :action => 'create', :participant_code => params[:participant_code]

#### BYPASSING QUIZ and second chat
#      when 'chat1_complete', 'quiz_score_reported'
#        redirect_to :controller => 'collaboration', :action => 'quiz_results'
#      when 'chat2_complete'
#        redirect_to :controller => 'collaboration', :action => 'money_decide'
      when 'chat1_complete', 'quiz_score_reported'  , 'chat2_complete'
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
    sid = session[:survey_code]
    case @participant.status

#### BYPASSING QUIZ and second chat
#    when 'chat1_complete'
#      stage = 2
#    when 'chat2_complete'
#      stage = 3
    when 'chat1_complete'
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
    @qualtrics_surveys = []
    @qualtrics_surveys.push({:code =>'SV_8GEE97brucNde6w', :description => 'CivilityPrototype - Development (RUNS LOCALLY)' })
    @qualtrics_surveys.push({:code =>'SV_1XnuT1xvFYiib8p', :description => 'CivilityPrototype - Development2 - redirect testing (RUNS LOCALLY)' })
    @qualtrics_surveys.push({:code =>'SV_3WzzOUymYH3CGb2', :description => 'CivilityPrototype - Production (Selah testing)' })
    @qualtrics_surveys.push({:code =>'SV_080tIOwpxrlBam1', :description => 'CivilityPrototype - Production (Livia)' })
#    @qualtircs_surveys.push({:code =>'', :description => '' })

    render :need_more_info
  end
  
  def encode_payout(x)
    a, b, c = 7, 19, 31
    (x+b+rand(b)*c)*a
  end
  private :encode_payout

  def good_bye
    @participant = Participant.find_by_code(params[:participant_code])

    @payout_code = 'LC' + encode_payout(@participant.final_payout.round).to_s unless @participant.final_payout.nil?
#    @payout_code = 'LC' + encode_payout(8).to_s
    puts @participant.inspect

    finished_text = 'You are finished.<br/>'
    finished_text += "Amazon Turk payout code:#{@payout_code}" unless @payout_code.nil?
    render :text => finished_text
  end

  def no_partners
    if session[:participant_code]
      @participant = Participant.find_by_code(session[:participant_code])
    else
      @participant = Participant.find_by_code(params[:participant_code].match(/\s/))
    end
    session[:participant_id] = @participant.id

    redirect_to :controller => 'pairings', :action => 'create'
    
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
      status = Participant.get_status_by_code(params[:participant_code].match(/\s/))
      render :json => {:status => status}
    else
      render :json => {:error => "Must supply participant code"}
    end
  end

end
