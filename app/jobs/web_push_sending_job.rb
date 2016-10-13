class WebPushSendingJob < ApplicationJob
  queue_as :general

  def perform(message)
    send_web_push(JSON.parse(message, {symbolize_names: true})) if enable?
  end

  def send_web_push(msg)
    params = {
      title: msg[:title],
      body: msg[:body],
      icon: get_icon_url,
      url: msg[:url],
      apikey: apikey,
    }
    uri = URI.parse("#{base_api_url}/send")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req["Content-Type"] = "application/json"
    req.body = params.to_json
    res = https.request(req)
  end

  def get_icon_url
    uri = URI.parse("#{base_api_url}/head")
    json = Net::HTTP.get(uri)
    result = JSON.parse(json, {symbolize_names: true})
    return result[:icon].to_s
  end

  def enable?
    Settings.web_push.push7_appno.present? && Settings.web_push.push7_apikey.present?
  end

  def apikey
    Settings.web_push.push7_apikey
  end

  def base_api_url
    "https://api.push7.jp/api/v1/#{Settings.web_push.push7_appno}"
  end

end
