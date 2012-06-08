class QualtricsController < ApplicationController
  def see
    if params[:stage].empty?
      @stage = 1
    else
      @stage = params[:stage].to_i
    end

    if @stage==3
      redirect_to :action => 'done'
    end

    #making annonymous link assumption
    @qualtrics_url = "http://wharton.qualtrics.com/SE/?SID="+params[:SID].to_s+"&participant_id="+params[:participant_id] +"&stage=" + (@stage+1).to_s 

  end

  def done
  end

end
