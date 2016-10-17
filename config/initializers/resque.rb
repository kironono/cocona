require 'resque'
require 'resque/server'
require 'resque-scheduler'
require 'resque/scheduler/server'

Resque.redis = Redis.new(host: Settings.redis.host, port: Settings.redis.port)
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
