class DeploysController < ApplicationController

  def index
    @deploy = Deploy.new
    @builds  = Build.order('created_at DESC').passing.limit(10)
    @deploys = Deploy.order('created_at DESC').page(params[:page])
  end

  def show
    @deploy = Deploy.find(params[:id])
    @project = @deploy.project
    @commit  = @deploy.commit
  end

  def create
    @deploy = Deploy.new(deploy_params)
    @deploy.user = current_user

    @deploy.save!

    LaunchDeployJob.perform_later(@deploy)

    redirect_to @deploy, notice: "Deploy scheduled"
  end

  private

  def deploy_params
    params.require(:deploy).permit(:deploy_environment_id, :build_id)
  end
end
