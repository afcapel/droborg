class JobsController < ApplicationController

  def show
    @job  = Job.find(params[:id])

    @build   = @job.build
    @project = @build.project
  end
end