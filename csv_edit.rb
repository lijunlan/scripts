require 'csv'
require 'io/console'
require './google_translate'
require './google_place'

class TranslateCSV
  def initialize(in_path, out_path)
    @in_file_path = in_path
    @out_file_path = out_path
  end

  PAGE_SIZE = 80

  def translate_via_google_translation
    begin
      in_csv = CSV.read(@in_file_path)
      out_csv = CSV.new(File.open(@out_file_path, 'w'))
      need_to_translate_arrays = Array.new
      need_to_translate_array = Array.new
      in_csv.each_with_index do |row, index|
        next if index == 0
        need_to_translate_array << row[4]
        if need_to_translate_array.size == PAGE_SIZE || index == in_csv.size - 1
          need_to_translate_arrays << need_to_translate_array
          need_to_translate_array = Array.new
        end
      end
      translated_arrays = Array.new
      need_to_translate_arrays.each do |m_array|
        translated_arrays << GoogleTranslate::translate_multi(m_array)
      end
      in_csv.each_with_index do |row, index|
        if index == 0
          out_csv << row
        else
          row[5] = translated_arrays[(index - 1) / PAGE_SIZE][(index - 1) % PAGE_SIZE]
          out_csv << row
        end
      end
    rescue StandardError => e
      puts e
    ensure
      out_csv.close if out_csv
    end
  end

  def translate_via_google_place
    begin
      in_csv = CSV.read(@in_file_path)
      out_csv = CSV.new(File.open(@out_file_path, 'w'))
      need_to_translate_array = Array.new
      in_csv.each_with_index do |row, index|
        next if index == 0
        suffix = row[0].split(',')[1]
        if suffix && !row[4].include?(suffix)
          need_to_translate_array << row[4] + suffix
        else
          need_to_translate_array << row[4]
        end
      end
      translated_arrays = GooglePlace::search_multi(need_to_translate_array)
      in_csv.each_with_index do |row, index|
        if index == 0
          out_csv << row
        else
        #  puts need_to_translate_array[index - 1] unless translated_arrays[index - 1]
          row[5] = translated_arrays[index - 1] unless translated_arrays[index - 1] == nil || translated_arrays[index - 1] == ""
          out_csv << row
        end
      end
    rescue StandardError => e
      puts e
    ensure
      out_csv.close if out_csv
    end
  end
end

trans = TranslateCSV.new('/Users/junlan_li/Downloads/bulk_export_csv_1.csv', '/Users/junlan_li/Downloads/translated1.csv')
#trans.translate_via_google_translation
trans.translate_via_google_place
#trans_t = TranslateCSV.new('/Users/junlan_li/Downloads/bulk_export_csv.csv','/Users/junlan_li/Downloads/google_translate.csv')
#trans_t.translate_via_google_translation
