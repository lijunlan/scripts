require 'csv'
require 'io/console'
require 'json'
require './google_get_bouding_coordinate'

class Jsonfy
  def initialize(in_path)
    @in_file_path = in_path
  end

  def add_distance(lat, lng, distance, isSW)
    new_lat = isSW ? lat - distance * 0.01 : lat + distance * 0.01
    new_lng = isSW ? lng - distance * 0.01 : lng + distance * 0.01
    {'lat' => new_lat, 'lng' => new_lng}
  end

  def list_name(city, list, list2)
    row = Array.new
    list.each do |l|
      next if l == nil || l.size == 0
      line = Array.new
      line << 'none'
      line << city
      line << l
      row << line
    end
    list2.each do |l|
      next if l == nil || l.size == 0
      line = Array.new
      line << 'none'
      line << city
      line << l
      row << line
    end
    row
  end

  def arrayIt(list)
    return 'ARRAY()' if list == nil
    r = 'ARRAY('
    list.each_with_index do |row, i|
      r += '\'' + row + '\''
      r += ',' unless i == list.length - 1
    end
    r += ')'
    r
  end

  def jsonfy
    begin
      in_csv = CSV.read(@in_file_path)
      index = 0
      city = nil
      city_localized = nil
      scenic = nil
      station = nil
      scenic_bounding = nil
      station_bounding = nil
      json = nil
      poi_data = {}
      in_csv.each do |row|
        if index % 4 == 0
          city = row[0]
          scenic = Array.new
          row.each_with_index do |column, i|
            next if i == 0
            next if column == nil || column.size == 0
            scenic << column
          end
        end
        if index % 4 == 1
          city_localized = row[0]
          scenic_bounding = Array.new
          row.each_with_index do |column, i|
            next if i == 0
            next if column == nil || column.size == 0
            geo = GoogleGeo::get_geos(city_localized, column)
            new_ne = add_distance(geo[:ne_lat], geo[:ne_lng], 1, false)
            new_sw = add_distance(geo[:sw_lat], geo[:sw_lng], 1, true)
            scenic_bounding << { place_name: scenic[i - 1], ne_lat: new_ne['lat'], ne_lng: new_ne['lng'], sw_lat: new_sw['lat'], sw_lng: new_sw['lng'] }
           # puts "\"#{city_localized}, #{column}\", https://www.airbnbchina.cn/s/#{city}/homes?refinement_paths%5B%5D=%2Fhomes&allow_override%5B%5D=&ne_lat=#{new_ne['lat']}&ne_lng=#{new_ne['lng']}&sw_lat=#{new_sw['lat']}&sw_lng=#{new_sw['lng']}&search_by_map=true&s_tag=eaHa_CMj"
          end
        end
        if index % 4 == 2
          station = Array.new
          row.each_with_index do |column, i|
            next if i == 0
            next if column == nil || column.size == 0
            station << column
          end
        end
        if index % 4 == 3
          station_bounding = Array.new
          row.each_with_index do |column, i|
            next if i == 0
            next if column == nil || column.size == 0
            geo = GoogleGeo::get_geos(city_localized, column)
            new_ne = add_distance(geo[:ne_lat], geo[:ne_lng], 1, false)
            new_sw = add_distance(geo[:sw_lat], geo[:sw_lng], 1, true)
            station_bounding << { place_name: station[i - 1], ne_lat: new_ne['lat'], ne_lng: new_ne['lng'], sw_lat: new_sw['lat'], sw_lng: new_sw['lng'] }
            #puts "\"#{city_localized}, #{column}\", https://www.airbnbchina.cn/s/#{city}/homes?refinement_paths%5B%5D=%2Fhomes&allow_override%5B%5D=&ne_lat=#{new_ne['lat']}&ne_lng=#{new_ne['lng']}&sw_lat=#{new_sw['lat']}&sw_lng=#{new_sw['lng']}&search_by_map=true&s_tag=eaHa_CMj"
          end
          json = {
            :station => station_bounding,
            :scenic => scenic_bounding,
            :subway => [],
            :zone => [],
            :region => [],
          }

          #puts "INSERT INTO TABLE search_poi_data.place_area SELECT '#{city}', #{arrayIt(json[:station])}, #{arrayIt(json[:scenic])}, #{arrayIt(json[:subway])}, #{arrayIt(json[:zone])}, #{arrayIt(json[:region])} FROM search_poi_data.dummy;"
          #puts "INSERT INTO TABLE search_poi_data.place_area SELECT '#{city}', '#{JSON.generate(json)}' FROM search_poi_data.dummy;"
          #puts city
          #puts JSON.pretty_generate(json)
        end
        index += 1
        #puts city
        poi_data[city] = json if city
      end
      JSON.pretty_generate(poi_data)
    rescue StandardError => e
      puts e.backtrace
    end
  end
end

rpi = Jsonfy.new('/Users/junlan_li/Downloads/POIs_V1_inbound.csv')
puts rpi.jsonfy
