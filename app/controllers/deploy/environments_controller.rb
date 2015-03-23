class Deploy::EnvironmentsController < ApplicationController

  before_action :load_deploy_environment, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all.includes(:deploy_environments).reject { |p| p.deploy_environments.empty? }
  end

  def show
    @deploys = @environment.deploys.page(params[:page])
    @last_deploy = @environment.last_deploy
  end

  def new
    @environment = Deploy::Environment.new()
  end

  def create
    @environment = Deploy::Environment.new(deploy_environment_params)

    @environment.save!
    redirect_to deploy_environments_path, notice: "Deploy environment successfully added."
  end

  def edit
  end

  def update
    if @environment.update_attributes!(deploy_environment_params)
      redirect_to deploy_environments_path, notice: "Deploy environment successfully updated."
    end
  end

  def destroy
    @environment.destroy!
  end

  private

  def deploy_environment_params
    params.require(:deploy_environment).permit(:name, :project_id, :deploy_command)
  end

  def load_deploy_environment
    @environment = Deploy::Environment.find(params[:id])
  end
end
