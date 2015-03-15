class DeploysController < ApplicationController

  def index
    @deploy = Deploy.new
    @builds  = Build.order('updated_at DESC').passing.limit(10)
    @deploys = Deploy.all.order('updated_at DESC')
  end

  def show
    @deploy = Deploy.find(params[:id])
    @project = @deploy.project
  end

  def create
    @deploy = Deploy.create!(deploy_params)
    @deploy.create_jobs

    LaunchDeployJob.perform_later(@deploy)

    respond_with @deploy
  end

  private

  def deploy_params
    params.require(:deploy).permit(:deploy_environment_id, :revision)
  end
end
