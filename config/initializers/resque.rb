require 'resque'
require 'resque/server'
require 'resque-scheduler'
require 'resque/scheduler/server'

redis_config = YAML.load_file(Rails.root.join('config', 'redis.yml'))

Resque.redis = Redis.new(host: redis_config[:host], port: redis_config[:port])
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
