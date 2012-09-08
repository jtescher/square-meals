module ApplicationHelper
  def foursquare_auth_url
    "https://foursquare.com/oauth2/authenticate?client_id=#{ENV['FOURSQUARE_CLIENT_ID']}&response_type=code&redirect_uri=#{oauth_callback_url}"
  end
end
