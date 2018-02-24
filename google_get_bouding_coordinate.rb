require 'net/http'
require 'json'
require 'concurrent'

module GoogleGeo

  @@link = 'https://maps.googleapis.com/maps/api/geocode/json'
  @@link_cn = 'https://maps.google.cn/maps/api/geocode/json'

  def self.get_params(query)
    {
      :address => query,
      :language => 'zh-CN',
      :key => 'AIzaSyBNUjSDjK1wrARoI-dcfRUOq57LLu7IvYE',
    }
  end

  def self.send_request(data)
    uri = URI(@@link)
    uri.query = URI.encode_www_form(data)
    Net::HTTP.get_response(uri)
  end
  
  def self.get_geos(city, places)
    place_array = places.split('/')
    geo_array = []
    place_array.each do |place|
      result = get_geo("#{city}, #{place}")
      unless result['status'] == 'OK'
        puts "#{city}, #{place}"
        puts result
        next
      end
      if !result['results'] || !result['results'].first || !result['results'].first['geometry']
        puts result
        next
      end
      geocoding = result['results'].first['geometry']['viewport']
      geo_ne = geocoding['northeast']
      geo_sw = geocoding['southwest']
      geo_array << { ne_lat: geo_ne['lat'], ne_lng: geo_ne['lng'], sw_lat: geo_sw['lat'], sw_lng: geo_sw['lng'] }
    end
    geo_ne_lat = -90
    geo_ne_lng = -180
    geo_sw_lat = 90
    geo_sw_lng = 180
    geo_array.each do |geo|
      geo_ne_lat = geo_ne_lat < geo[:ne_lat] ? geo[:ne_lat] : geo_ne_lat
      geo_ne_lng = geo_ne_lng < geo[:ne_lng] ? geo[:ne_lng] : geo_ne_lng
      geo_sw_lat = geo_sw_lat > geo[:sw_lat] ? geo[:sw_lat] : geo_sw_lat
      geo_sw_lng = geo_sw_lng > geo[:sw_lng] ? geo[:sw_lng] : geo_sw_lng
    end
    { ne_lat: geo_ne_lat, ne_lng: geo_ne_lng, sw_lat: geo_sw_lat, sw_lng: geo_sw_lng }
  end

  def self.get_geo(place)
    params = get_params(place)
    res = send_request(params)
    result = JSON.parse(res.body)
    #puts JSON.pretty_generate(result)
    #result
    #puts result['results']
    #unless result["status"] == 'OK'
    #  return nil
    #else
    #  return result
    #end
    #result["status"] == 'OK' ? result["results"][0]["name"] : nil
  end
end
#puts GoogleGeo::get_geo('广州，广州塔')
#puts GooglePlace::search_with_lg('Chongqing', 'en')
#puts GooglePlace::search('Santa Barbara United States')
#puts GooglePlace::search('West Virginia United States')
