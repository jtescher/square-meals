class RestaurantsController < ApplicationController
  def index
    url = "https://api.foursquare.com/v2/venues/explore?" +
            "ll=#{params[:lat]},#{params[:lng]}" +
            "&section=food" +
            "&limit=10" +
            "&oauth_token=#{current_user}"
    foursquare_json = HTTParty.get(url)
    @restaurants = foursquare_json['response']['groups'][0]['items']
  end
end
