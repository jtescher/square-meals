class SessionsController < ApplicationController
  def create
    url = "https://foursquare.com/oauth2/access_token?" +
        "client_id=#{ENV['FOURSQUARE_CLIENT_ID']}" +
        "&client_secret=#{ENV['FOURSQUARE_CLIENT_SECRET']}" +
        "&grant_type=authorization_code" +
        "&redirect_uri=#{oauth_callback_url}" +
        "&code=#{params[:code]}"
    response = HTTParty.get(url)
    cookies.permanent[:auth_token] = response['access_token']
    redirect_to root_url
  end

  def destroy
    cookies.delete :auth_token
    redirect_to root_url
  end
end