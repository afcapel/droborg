class DeploysController < ApplicationController

  def index
    @deploy = Deploy.new
    @builds  = Build.order('updated_at DESC').passing.limit(10)
    @deploys = Deploy.all.order('updated_at DESC')
  end
end
