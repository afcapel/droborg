class ProjectsController < ApplicationController
  before_filter :authorize
  before_filter :load_project, only: [:show, :edit, :update]
  respond_to :html, :json

  def show
    @builds  = @project.builds.order('id DESC')

    @page   = params[:page].present?   ? params[:page].to_i : 1
    @branch = normalize_branch_name

    skip = (@page - 1) * 5

    @branches = @project.branches

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
      setup_build_command: 'bundle install',
      setup_job_command: 'bundle exec rake db:create db:schema:load',
      after_job_command: 'bundle exec rake db:drop',
      test_files_patterns: 'spec/**/*_spec.rb, test/**/*_test.rb',
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
    params.require(:project).permit(:name, :type, :git_url, :workers, :env,
      :test_files_patterns, :setup_build_command, :setup_job_command, :after_job_command, :after_build_command)
  end
end