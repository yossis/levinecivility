class ParticipantsController < ApplicationController

  before_filter :find_participant_or_redirect, :except =>[:create]

  def create
    participant = Participant.find_or_create_by_code(params[:participant_code])
    if participant
      session[:participant_id] = participant.id
      redirect_to :controller => 'pairings', :action => 'create'
    else
      render :text => "Participant creation failed (possibly bad user code (#{params[:participant_code]}))"
    end
  end



end
