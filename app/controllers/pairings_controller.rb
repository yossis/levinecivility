class PairingsController < ApplicationController

  before_filter :find_participant_or_redirect

  def create  
    if @participant.partner.nil?
      @participant.establish_partner
    end
    if @participant.partner.nil?
      render 'collaboration/wait'
    else
      redirect_to :controller => 'collaboration', :action => 'chat', :which_chat => 1,
    end
  end

end
