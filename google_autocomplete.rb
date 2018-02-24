#AIzaSyAl5ZqxnpyOEgQh8p15zoJSzA26fb6xrT0
#
require 'net/http'
require 'json'

module GoogleAutocomplete

  @@link = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'

  def self.get_params(query)
    {
      :types => 'geocode',
      :input => query,
      :key => 'AIzaSyAl5ZqxnpyOEgQh8p15zoJSzA26fb6xrT0',
    }
  end

  def self.send_request(data)
    uri = URI(@@link)
    uri.query = URI.encode_www_form(data)
    Net::HTTP.get_response(uri)
  end

  def self.hint(place)
    params = get_params(place)
    res = send_request(params)
    result = JSON.parse(res.body)
    result["status"] == 'OK' ? result["predictions"][0]["description"] : nil
  end
end

#puts GoogleAutocomplete::hint('South Bay, CA')
