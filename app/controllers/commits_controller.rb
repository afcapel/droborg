class CommitsController < ApplicationController

  def show
    @build = Build.find_by(revision: params[:revision])
  end
end
