require 'net/http'
require 'json'
# project_id = "china-translate-184207"

#require 'google/cloud.storage'

module GoogleTranslate

  @@link = 'https://translation.googleapis.com/language/translate/v2'
#AIzaSyDv0Ig6kbQn05uOQ-h990oKfJVWzN_yjXU
#AIzaSyBf-7U-GTQhYMnBFbFJ57bKAZmSwQgGVTQ  -- lang
  def self.get_params(q)
    {
      :q => q,
      :source => 'en',
      :target => 'zh-CN',
      :key => 'AIzaSyDv0Ig6kbQn05uOQ-h990oKfJVWzN_yjXU',
    }
  end

  def self.get_params_with_target(q, target)
    {
      :q => q,
      :model => 'base',
      :target => target,
      :key => 'AIzaSyDv0Ig6kbQn05uOQ-h990oKfJVWzN_yjXU',
    }
  end

  def self.send_request(data)
    uri = URI(@@link)
    Net::HTTP.post_form(uri, data)
  end

  def self.translate_with_target(origin, target)
    params = get_params_with_target(origin, target)
    res = send_request(params)
    result = JSON.parse(res.body)
    result["data"]["translations"][0]["translatedText"]
  end

  def self.translate(origin)
    params = get_params(origin)
    res = send_request(params)
    result = JSON.parse(res.body)
    result["data"]["translations"][0]["translatedText"]
  end

  def self.translate_multi(origins)
    params = get_params(origins)
    res = send_request(params)
    result = JSON.parse(res.body)
    ans = Array.new
    begin
      result["data"]["translations"].each do |translation|
        ans << translation["translatedText"]
      end
    rescue StandardError => e
      puts res.body
      puts e
    end
    ans
  end
end
