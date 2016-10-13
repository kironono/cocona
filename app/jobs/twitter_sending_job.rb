class TwitterSendingJob < ApplicationJob
  queue_as :general

  def perform(message)
    msg = JSON.parse(message, {symbolize_names: true})
    send_tweet(msg) if enable?
  end

  def send_tweet(msg)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = Settings.twitter.consumer_key
      config.consumer_secret = Settings.twitter.consumer_secret
      config.access_token = Settings.twitter.access_token
      config.access_token_secret = Settings.twitter.access_token_secret
    end
    client.update(msg[:body])
  end

  def enable?
    Settings.twitter.consumer_key.present? &&
      Settings.twitter.consumer_secret.present? &&
      Settings.twitter.access_token.present? &&
      Settings.twitter.access_token_secret.present?
  end

end
