class StoriesController < ApplicationController
  def index
    projects = get_projects
    return redirect_to :controller => :users, :action => :logout if projects.nil?
    @stories = Story.all
    @story = Story.new
    prs = []
    projects.each do |project|
      prs << project.name
      prs << project.id
    end
    @projects = Hash[*prs.flatten]
    respond_to do |format|
      format.html
      format.js {@stories}
      format.json {render json: @stories}
    end
  end

  def create
    @story = Story.new(story_params)
    @stories = Story.all
    respond_to do |format|
      if @story.save
        format.html {redirect_to({ action: 'index' }, { notice: 'Story created successfully' })}
        format.js {}
        format.json {render json: @stories, status: :created, location: @story}
      else
        format.html {render action: "new"}
        format.json {render json: @story.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @story = Story.find(params[:id])
    delete_story
    @story.destroy
    @stories = Story.all
    redirect_to({ action: 'index' }, { notice: 'Story deleted successfully' })
  end

  def create_pivotal_story
    PivotalTracker::Client.token = session[:pivotal_token]
    @story = Story.find(params[:id])
    @project = PivotalTracker::Project.find(@story.project.to_i)
    @pivotal_story = @project.stories.create(:name => @story.title, :story_type => @story.story_type)
    @story.pivotal_id = @pivotal_story.id
    @story.save
  end

  private

  def story_params
    params.require(:story).permit(:title, :project, :story_type, :status, :blocker, :date, :created_by, :assigned_to)
  end

  def delete_story
    PivotalTracker::Client.token = session[:pivotal_token]
    project = PivotalTracker::Project.find(@story.project.to_i)
    project.stories.find(@story.pivotal_id).delete
  end

  def get_projects
    redirect_to :controller => :users, :action => :new if session[:pivotal_token].nil?
    PivotalTracker::Client.token = session[:pivotal_token]
    begin
      PivotalTracker::Project.all
    rescue
      nil
    end
  end
end
