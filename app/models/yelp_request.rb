require 'signet/oauth_1/client'

class YelpRequest
  
  def self.try_to_find_restaurant_review(name, lat, lng)
    #lat = '37.774929'
    #lng = '-122.419415'
    restaurants = hit_api("http://api.yelp.com/v2/search?term=#{name}&ll=#{lat},#{lng}&limit=3")["businesses"]
    
    return false if restaurants.size == 0
    
    if restaurants.size == 1
      return restaurants[0]
    else
      restaurants.each do |restaurant|
        # try to find an exact match on the name
        return restaurant if restaurant["name"] == name
      end
      return false
    end
  end
  
  def self.hit_api(query)
    client = Signet::OAuth1::Client.new(
      :client_credential_key         => 'wB1vluQznPtGM0-aXRKjfA',
      :client_credential_secret      => 'GliwV81s18DA1vF3aRcU6CnDyyU',
      :token_credential_key     => '_foJDIdpVqUQ-4lISxm_2k2jdeO9k63I',
      :token_credential_secret  => 'uGiTZgY4piqgHn7B1JuD-SlHsZM'
    )
    
    response = client.fetch_protected_resource(
      :uri => query
    )
    
    json = ActiveSupport::JSON.decode(response.body)
  end
  
end