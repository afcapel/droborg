class DeployScriptsController < ApplicationController

  def index
    @builds  = Build.order('updated_at DESC').passing.limit(10)
    @deploys = Deploy.all.order('updated_at DESC')
  end
end
