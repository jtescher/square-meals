class RestaurantsController < ApplicationController
  respond_to :json

  def index
    url = "https://api.foursquare.com/v2/venues/explore?" +
            "ll=#{params[:lat]},#{params[:lng]}" +
            "&section=food" +
            "&limit=10" +
            "&oauth_token=#{current_user}"
    p url
    respond_with HTTParty.get(url)
  end
end
