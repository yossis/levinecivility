class MessagesController < ApplicationController
  def create
    @message = Message.create(:participant_id => params[:participant_id], :body => params[:messagebody])
    @messages = Participant.find(params[:participant_id]).pairing.messages.order("created_at DESC")
  end

  def list
  end

end
