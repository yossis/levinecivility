class PairingsController < ApplicationController

  before_filter :find_participant_or_redirect

  def create  
    if @participant.partner.nil?
      @participant.establish_partner
    end
    
    if @participant.partner.nil?
      if @participant.idle_time > CustomConfig.hash[:waitforpartner_timeout_constant]
        @participant.status = 'no_partners'
        @participant.save
        render :text => "No partners available"
      else
        render 'collaboration/wait'
      end
    else
      redirect_to :controller => 'collaboration', :action => 'begin_chat'
    end
  end

end



