class ParticipantsController < ApplicationController

  before_filter :find_participant_or_redirect, :except =>[:create]

  def create
    participant = Participant.find_or_create_by_code(params[:participant_code])
    session[:participant_id] = participant.id
    redirect_to :controller => 'pairings', :action => 'create'
  end



end
