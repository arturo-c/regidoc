class VisitorsController < ApplicationController

  def new
    session[:pivotal_token] = 'AItOawndcTXcUSs5LBMj6U6u6ZmeQLkVuSIY3Lk'
    PivotalTracker::Client.token = session[:pivotal_token]
    redirect_to :controller => 'stories', :action => 'index'
  end

end
