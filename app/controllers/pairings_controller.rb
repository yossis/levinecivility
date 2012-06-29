class PairingsController < ApplicationController

  before_filter :find_participant_or_redirect

  def create  
    if @participant.partner.nil?
      @participant.establish_partner
    end
    if @participant.partner.nil?
      render 'collaboration/wait'
    else
      redirect_to :controller => 'collaboration', :action => 'begin_chat'
    end
  end

end
