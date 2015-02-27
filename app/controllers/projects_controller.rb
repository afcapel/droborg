class ProjectsController < ApplicationController

  before_filter :load_project, only: [:show, :edit, :update, :refresh]
  before_filter :check_if_ready, only: :show

  respond_to :html, :json

  def show
    @builds  = @project.builds.order('id DESC')

    @page   = params[:page].present? ? params[:page].to_i : 1
    @branch = normalize_branch_name
    @repo   = @project.repo

    skip = (@page - 1) * 5

    @branches = Rails.cache.fetch "project-#{@project.id}-branches", expires_in: 5.minutes do
      @repo.branches
    end

    commits       = @repo.commits(@branch, 5, skip)
    commits_count = @repo.commit_count(@branch)

    @commits = Kaminari.paginate_array(commits, total_count: commits_count).page(@page).per(5)
  end

  def index
    @projects = Project.all
  end

  def new
    @org   = Github.org
    @repos = Github.repos
  end

  def create
    @project = Project.create_from_github_repo(params[:github_repo])

    if @project.save
      SetupProjectJob.perform_later(@project)
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

  def refresh
    Rails.cache.delete "project-#{@project.id}-branches"

    @repo = @project.repo
    @repo.fetch
    @repo.branches

    redirect_to project_path(@project)
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
