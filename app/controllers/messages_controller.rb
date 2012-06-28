class MessagesController < ApplicationController

  before_filter :find_participant_or_redirect
  
  def create
    @message = Message.create(:participant_id => @participant.id, :body => params[:messagebody])

    #this is for updating the chat screen after the message is created
    @messages = @participant.pairing.messages.order("created_at DESC")
  end

  def list
    @messages = @participant.pairing.messages.order("created_at DESC")
  end

end
