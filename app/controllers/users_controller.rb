class UsersController < ApplicationController

  def new
    @user = User.new
    redirect_to :controller => 'stories', :action => 'index' if session[:pivotal_token]
  end

  def create
    session[:pivotal_token] = params[:user][:token]
    PivotalTracker::Client.token = session[:pivotal_token]
    begin
      @projects = PivotalTracker::Project.all
      redirect_to :controller => 'stories', :action => 'index'
    rescue
      redirect_to :action => 'new'
    end
  end

  def logout
    session[:pivotal_token] = nil
    redirect_to :action => 'new'
  end
end
