require 'csv'
require 'io/console'
require './google_translate'
require 'concurrent'
require './google_place'

class ChooseChina
  def initialize(in_path, out_path, out_path_2)
    @in_file_path = in_path
    @out_file_path = out_path
    @out_file_path_2 = out_path_2
  end

  def choose
    begin
      in_csv = CSV.read(@in_file_path)
      out_csv = CSV.new(File.open(@out_file_path, 'w'))
      out_csv_2 = CSV.new(File.open(@out_file_path_2, 'w'))
      in_csv.each_with_index do |row, index|
        datas = row[0].split('.')
        details = datas[2].split(',')
        country = details[1] if details.size > 1
        if country == ' China'
          out_csv << row
        else
          out_csv_2 << row
        end
      end
    rescue StandardError => e
      puts e
    ensure
      out_csv.close if out_csv
      out_csv_2.close if out_csv_2
    end
  end
end

choose = ChooseChina.new('/Users/junlan_li/Downloads/excluded_key.csv', '/Users/junlan_li/Downloads/excluded_key_china.csv', '/Users/junlan_li/Downloads/excluded_key_other.csv')
choose.choose

