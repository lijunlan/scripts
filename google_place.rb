#AIzaSyAl5ZqxnpyOEgQh8p15zoJSzA26fb6xrT0
#
require 'net/http'
require 'json'
require 'concurrent'
require './google_autocomplete'

module GooglePlace

  @@link = 'https://maps.googleapis.com/maps/api/place/textsearch/json'

  def self.get_params(query)
    {
      #:type => ['locality', 'country', 'sublocality', 'cities'],
      :language => 'zh-CN',
      :query => query,
#      :key => 'AIzaSyAl5ZqxnpyOEgQh8p15zoJSzA26fb6xrT0',
      :key => 'AIzaSyBbS64GazWNFffAxTbVuf-9UsTRbrXNUo8',
#      :key => 'AIzaSyBf-7U-GTQhYMnBFbFJ57bKAZmSwQgGVTQ',
    }
  end

  def self.get_params_with_lg(query, language)
    {
      :language => language,
      :query => query,
      :key => 'AIzaSyAl5ZqxnpyOEgQh8p15zoJSzA26fb6xrT0',
    }
  end

  def self.send_request(data)
    uri = URI(@@link)
    uri.query = URI.encode_www_form(data)
    Net::HTTP.get_response(uri)
  end

  def self.search(place)
    #whole_place = GoogleAutocomplete::hint(place)
 #   puts whole_place
 #   params = get_params(whole_place ? whole_place : place)
    params = get_params(place)
    res = send_request(params)
    result = JSON.parse(res.body)
 #   puts res.body
    unless result["status"] == 'OK'
      puts res.body
      return nil
    else
      return result["results"][0]["name"]
    end
    #result["status"] == 'OK' ? result["results"][0]["name"] : nil
  end

  def self.search_with_lg(place, language)
    params = get_params_with_lg(place, language)
    res = send_request(params)
    result = JSON.parse(res.body)
    result["status"] == 'OK' ? result["results"][0]["name"] : nil
  end

  def self.search_multi(places)
    result_array = Array.new(places.length)
    pool = Concurrent::FixedThreadPool.new(50)
    places.each_with_index do |place, index|
      pool.post do
        result_array[index] = GooglePlace::search(place)
      end
    end
    pool.shutdown
    pool.wait_for_termination
    result_array
  end
end


#puts GooglePlace::search_with_lg('Chongqing', 'en')
#puts GooglePlace::search('Santa Barbara United States')
#puts GooglePlace::search('West Virginia United States')
