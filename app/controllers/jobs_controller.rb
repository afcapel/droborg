class JobsController < ApplicationController

  def index
    @jobs = Build::Job.not_finished
  end

  def show
    @job  = Build::Job.find(params[:id])

    @build   = @job.build
    @project = @build.project
  end
end
