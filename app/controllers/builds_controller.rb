class BuildsController < ApplicationController
  respond_to :html, :json

  def index
    @builds = Build.all.order('updated_at DESC')
  end

  def show
    @build   = Build.find(params[:id])

    @project = @build.project
    @commit  = @build.commit
    @jobs    = @build.jobs.order('number ASC').all
  end

  def create
    @project = Project.find(params[:project_id])

    @build = Build.new(project: @project, revision:  params[:revision], user: current_user)
    @build.save! && @build.schedule!

    respond_with @build
  end


end