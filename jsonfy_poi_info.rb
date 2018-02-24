require 'csv'
require 'io/console'
require 'json'

class Jsonfy
  def initialize(in_path)
    @in_file_path = in_path
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
      scenic = nil
      station = nil
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
        if index % 4 == 2
          station = Array.new
          row.each_with_index do |column, i|
            next if i == 0
            next if column == nil || column.size == 0
            station << column
          end
        end
        if index % 4 == 3
          json = {
            :station => station,
            :scenic => scenic,
            :subway => [],
            :zone => [],
            :region => [],
          }
          #puts "INSERT INTO TABLE search_poi_data.place_area SELECT '#{city}', #{arrayIt(json[:station])}, #{arrayIt(json[:scenic])}, #{arrayIt(json[:subway])}, #{arrayIt(json[:zone])}, #{arrayIt(json[:region])} FROM search_poi_data.dummy;"
          puts "INSERT INTO TABLE search_poi_data.place_area SELECT '#{city}', '#{JSON.generate(json)}' FROM search_poi_data.dummy;"
          #puts city
          #puts JSON.pretty_generate(json)
          puts ''
        end
        index += 1
      end
    rescue StandardError => e
      puts e
    end
  end
end

rpi = Jsonfy.new('/Users/junlan_li/Downloads/POIsV1inbound.csv')
rpi.jsonfy
