class SessionsController < ApplicationController

  layout 'public'
  skip_before_filter :authorize

  def create
    user = user_from_omniauth
    session[:user_id] = user.id
    redirect_to root_url, notice: "Signed in."
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end

  private

  def user_from_omniauth
    github_uid = env["omniauth.auth"]["uid"]

    user = User.where(github_uid: github_uid).first || User.new

    auth = env["omniauth.auth"]
    info = auth["info"]

    user.github_uid = auth["uid"]
    user.name  = info["name"]
    user.email = info["email"]
    user.avatar_url = info["image"]
    user.github_username = info["nickname"]
    user.github_token = auth["credentials"]["token"]

    user.save!

    user
  end
end
