class VisitorsController < ApplicationController

  def new
    session[:pivotal_token] = 'ca764d6bb8a17352be715f27bdafbd69'
    PivotalTracker::Client.token = session[:pivotal_token]
    redirect_to :controller => 'stories', :action => 'index'
  end

end
