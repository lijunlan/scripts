require 'csv'
require 'io/console'
require './google_translate'
require 'concurrent'
require './google_place'

class FormatCSV
  def initialize(in_path, out_path)
    @in_file_path = in_path
    @out_file_path = out_path
  end

  def checkRow(row)
    row.length == 2 && row[1].is_a?(String) && row[1].to_i >= 500
  end

  def format
    begin
      in_csv = CSV.read(@in_file_path)
      out_csv = CSV.new(File.open(@out_file_path, 'w'))
      need_to_translate_array = Array.new
      in_csv.each_with_index do |row, index|
        next if index == 0
        next unless checkRow(row)
        datas = row[0].split('.')
        category = datas[1]
        details = datas[2].split(',')
        name = details[0]
        country = details[1] if details.size > 1
        next if !name || name == ""
        name = '朝阳区' if name == '朝阳'
        need_to_translate_array << {:key => name, :country => country, :category => category}
      end
      translated_array = Array.new(need_to_translate_array.length)
      pool = Concurrent::FixedThreadPool.new(100)
      need_to_translate_array.each_with_index do |row, index|
        pool.post do
          begin
            #puts "index: #{index}, key: #{row[:key]}"
            #translated = GoogleTranslate::translate_with_target(row[:key], 'en')
            translated = GooglePlace::search_with_lg(row[:key], 'en')
            if !translated || translated.size == 0
              translated = GoogleTranslate::translate_with_target(row[:key], 'en')
            end
            #puts "key: #{row[:key]}, trans: #{translated}"
            puts "translate result is empty, origin: #{row[:key]}" if !translated || translated.size == 0
            translated_array[index] = row.merge({:default => translated})
          rescue StandardError => e
            puts e
          end
        end
      end
      pool.shutdown
      pool.wait_for_termination
      translated_array.each do |row|
        out_csv << [row[:category], row[:country], row[:key], row[:default]]
      end
    rescue StandardError => e
      puts e
    ensure
      out_csv.close if out_csv
    end
  end
end

format = FormatCSV.new('/Users/junlan_li/Downloads/sqllab_untitled_query_2_20171106T151955.csv', '/Users/junlan_li/Downloads/formal_format_place.csv')
format.format

