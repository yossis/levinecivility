class QualtricsController < ApplicationController
  def empty
  end

  def see
    if params[:stage].nil? || params[:SID].nil? || params[:participant_id].nil?
      render 'empty'
    else
      @stage = params[:stage].to_i    
      if @stage==3
        redirect_to :action => 'done'
      end    
      #making annonymous link assumption
      @qualtrics_url = "http://wharton.qualtrics.com/SE/?SID="+params[:SID].to_s+"&participant_id="+params[:participant_id] +"&stage=" + (@stage+1).to_s 
    end
  end

  def done
  end

end
