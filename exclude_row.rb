require 'csv'
require 'io/console'
require 'set'

class ExcludeRow
  def initialize(in_path_whole, in_path_exclude, out_path)
     @in_file_path_wh = in_path_whole
     @in_file_path_ex = in_path_exclude
     @out_file_path = out_path
  end

  def exclude
    begin
      in_csv_wh = CSV.read(@in_file_path_wh)
      in_csv_ex = CSV.read(@in_file_path_ex)
      out_csv = CSV.new(File.open(@out_file_path, 'w'))
      record = Set.new
      in_csv_ex.each_with_index do |row, index|
        next if index == 0
        record << row[0]
      end
      in_csv_wh.each_with_index do |row, index|
        next if index == 0
        next if record.include?(row[0])
        out_csv << row
      end
    rescue StandardError => e
      puts e
    ensure
      out_csv.close if out_csv
    end
  end
end

ex = ExcludeRow.new('/Users/junlan_li/Downloads/sqllab_untitled_query_2_20171207T124531.csv', '/Users/junlan_li/Downloads/bulk_export_csv_3.csv', '/Users/junlan_li/Downloads/excluded_key3.csv')
ex.exclude
