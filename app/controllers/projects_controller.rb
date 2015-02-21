class ProjectsController < ApplicationController

  before_filter :authorize
  before_filter :load_project, only: [:show, :edit, :update]
  before_filter :check_if_ready, only: :show

  respond_to :html, :json

  def show
    @builds  = @project.builds.order('id DESC')

    @page   = params[:page].present? ? params[:page].to_i : 1
    @branch = normalize_branch_name

    skip = (@page - 1) * 5

    @branches = Rails.cache.fetch "project-#{@project.name}-branches", expires_in: 5.minutes do
      @project.git_fetch
      @project.branches
    end

    commits       = @project.commits(@branch, 5, skip)
    commits_count = @project.commit_count(@branch)

    @commits = Kaminari.paginate_array(commits, total_count: commits_count).page(@page).per(5)
  end

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new(
      workers: 1,
      env: 'RAILS_ENV=test'
      )
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: 'Project successfully created.'
    else
      render 'new'
    end
  end

  def update
    @project.update_attributes(project_params)

    respond_with @project, notice: 'Project successfully updated'
  end

  def destroy
    @project.destroy
    respond_with @project
  end

  private

  def load_project
    @project = Project.find(params[:id])
  end

  def check_if_ready
    render 'cloning' unless @project.ready?
  end

  def normalize_branch_name
    case params[:branch]
    when /^origin\/(\w+)/
      params[:branch]
    when NilClass, /$\s*^/
      'origin/master'
    else
      "origin/#{params[:branch]}"
    end
  end

  def project_params
    params.require(:project).permit(:name, :type, :git_url, :workers, :env)
  end
end
