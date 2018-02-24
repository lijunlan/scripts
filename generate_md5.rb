require 'csv'
require 'io/console'
require 'digest'

class GenerateMD5
  def initialize(in_path, out_path)
    @in_file_path = in_path
    @out_file_path = out_path
  end

  def generate
    begin
      in_csv = CSV.read(@in_file_path)
      out_csv = CSV.new(File.open(@out_file_path, 'w'))
      in_csv.each_with_index do |row, index|
        if index == 0
          out_csv << row
          next
        end
        if row[5] == nil || row[5] == ""
          row[3] = ""
        else
          row[3] = Digest::MD5.hexdigest(row[5])
        end
        if row[4] == nil || row[4] == ""
          row[2] = ""
        else
          row[2] = Digest::MD5.hexdigest(row[4])
        end
        out_csv << row
      end
    ensure
      out_csv.close if out_csv
    end
  end
end

g5 = GenerateMD5.new('/Users/junlan_li/Downloads/translated11.csv', '/Users/junlan_li/Downloads/translated11_md5.csv')
g5.generate
