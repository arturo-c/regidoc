class StoriesController < ApplicationController
  def index
    @stories = Story.all
    @story = Story.new
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
        create_pivotal_story
        format.html {redirect_to @story, notice: 'Story created successfully'}
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
    delete_pivotal_story
    @story.destroy
    @stories = Story.all
    render :index
  end

  private

  def story_params
    params.require(:story).permit(:title, :story_type, :status, :blocker, :date, :created_by, :assigned_to)
  end

  def create_pivotal_story
    PivotalTracker::Client.token = session[:pivotal_token]
    @project = PivotalTracker::Project.find(263731)
    @pivotal_story = @project.stories.create(:name => @story.title, :story_type => @story.story_type)
    @story.pivotal_id = @pivotal_story.id
    @story.save
  end

  def delete_pivotal_story
    PivotalTracker::Client.token = session[:pivotal_token]
    project = PivotalTracker::Project.find(263731)
    project.stories.find(@story.pivotal_id).delete
  end
end
