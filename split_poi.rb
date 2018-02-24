require 'csv'
require 'io/console'

class SplitCSV
  def initialize(in_path, out_path)
    @in_file_path = in_path
    @out_file_path = out_path
  end

  def do_split
    begin
      in_csv = CSV.read(@in_file_path)
      out_csv = CSV.new(File.open(@out_file_path, 'w'))
      in_csv.each_with_index do |row, index|
        new_row = []
        row.each do |column|
          if column && column.include?('/')
            new_columns = column.split('/')
            new_row.concat(new_columns)
          else
            new_row << column
          end
        end
        out_csv << new_row
      end
    rescue StandardError => e
      puts e
    ensure
      out_csv.close if out_csv
    end
  end
end

trans = SplitCSV.new('/Users/junlan_li/Downloads/POI_outbound.csv', '/Users/junlan_li/Downloads/POI_outbound_split.csv')
#trans.translate_via_google_translation
trans.do_split
