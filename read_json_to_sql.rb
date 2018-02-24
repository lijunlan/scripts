require 'json'

inbound_json_string = File.read('/Users/junlan_li/Downloads/inbound_json.txt')
outbound_json_string = File.read('/Users/junlan_li/Downloads/outbound_json.txt')

inbound = JSON.parse(inbound_json_string)
outbound = JSON.parse(outbound_json_string)

inbound.keys.each do |key|
  puts "INSERT INTO search_poi_data.place_area VALUES ('#{key}', '#{JSON.generate(inbound[key])}');"
end

outbound.keys.each do |key|
  puts "INSERT INTO search_poi_data.place_area VALUES ('#{key}', '#{JSON.generate(outbound[key])}');"
end
