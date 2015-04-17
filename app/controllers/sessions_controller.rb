class SessionsController < ApplicationController
  def new
    redirect_to '/auth/github'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by(github_id: auth[:uid]) || User.create_by_github(auth)
    sign_in(user)
    redirect_to root_url
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
