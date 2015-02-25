class JobsController < ApplicationController

  def index
    @jobs = Job.not_finished
  end

  def show
    @job  = Job.find(params[:id])

    @build   = @job.build
    @project = @build.project
  end
end
