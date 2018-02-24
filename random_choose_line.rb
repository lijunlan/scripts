require 'csv'
require 'io/console'

class RandomChooseLine
  def initialize(in_path, out_path)
    @in_file_path = in_path
    @out_file_path = out_path
  end

  def chooseLine
    begin
      in_csv = CSV.read(@in_file_path)
      out_csv = CSV.new(File.open(@out_file_path, 'w'))
      randomMaker = Random.new
      in_csv.each_with_index do |row, index|
        next if index == 0
        number = randomMaker.rand(1000)
        next if number < 500 || number >= 600
        out_csv << row
      end
    rescue StandardError => e
      puts e
    ensure
      out_csv.close if out_csv
    end
  end
end

rc = RandomChooseLine.new('/Users/junlan_li/Downloads/bulk_export_csv_2.csv', '/Users/junlan_li/Downloads/bulk_export_csv_2_simple.csv')
rc.chooseLine

