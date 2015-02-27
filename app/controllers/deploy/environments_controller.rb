class Deploy::EnvironmentsController < ApplicationController

  def index
    @projects = Project.all.includes(:deploy_environments).reject { |p| p.deploy_environments.empty? }
  end

  def new
    @environment = Deploy::Environment.new()
  end

  def create
    @environment = Deploy::Environment.new(deploy_environment_params)

    @environment.save!
    redirect_to deploy_environments_path, notice: "Deploy environment successfully added."
  end

  private

  def deploy_environment_params
    params.require(:deploy_environment).permit(:name, :project_id, :env)
  end
end
