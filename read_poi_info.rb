require 'csv'
require 'io/console'

class ReadPOIInfo
  def initialize(in_path, out_path)
    @in_file_path = in_path
    @out_file_path = out_path
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

  def read
    begin
      in_csv = CSV.read(@in_file_path)
      out_csv = CSV.new(File.open(@out_file_path, 'w'))
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
            scenic << column
          end
        end
        if index % 4 == 2
          station = Array.new
          row.each_with_index do |column, i|
            next if i == 0
            station << column
          end
        end
        if index % 4 == 3
          list = list_name(city, scenic, station)
          list.each do |l|
            out_csv << l
          end
        end
        index += 1
      end
    rescue StandardError => e
      puts e
    ensure
      out_csv.close if out_csv
    end
  end
end

rpi = ReadPOIInfo.new('/Users/junlan_li/Downloads/POIsV1outbound.csv','/Users/junlan_li/Downloads/POI1.csv')
rpi.read
