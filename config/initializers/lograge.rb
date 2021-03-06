Rails.application.configure do
  path = "#{Rails.root}/log/lograge_#{Rails.env}.log"
  config.lograge.logger = ActiveSupport::Logger.new(path, 10, 10.megabytes)
  config.lograge.enabled = true
  config.lograge.keep_original_rails_log = true
  config.lograge.formatter = Lograge::Formatters::Logstash.new

  config.lograge.custom_options = lambda do |event|
    {
      host: event.payload[:host],
      username: event.payload[:username],
    }
  end
end
