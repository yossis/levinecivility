class ParticipantsController < ApplicationController

  def create
    participant = Participant.find_or_create_by_code(params[:participant_code])
    redirect_to :controller => :qualtrics, :action => :enter, :participant_code => participant.code
  end

end
