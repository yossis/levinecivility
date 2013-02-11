class AdminController < ApplicationController

  def export
    @confighash = CustomConfig.hash
    render 'admin'
  end

  def export_participants
    send_data Participant.text_export, :filename => 'participants.csv', :type => 'text/csv'
  end

  def export_pairings
    send_data Pairing.text_export, :filename => 'pairings.csv', :type => 'text/csv'
  end

  def export_messages
    send_data Message.text_export, :filename => 'messages.csv', :type => 'text/csv'
  end
  
end
