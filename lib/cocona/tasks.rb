namespace :cocona do

  desc "Start a Worker"
  task worker: :environment do
    require 'resque'

    ENV['QUEUE'] = 'general'

    worker = Resque::Worker.new
    worker.log "Starting worker #{self}"
    worker.work(Settings.worker.polling_interval || 1) # interval, will block
  end

  desc "Start a Recorder"
  task recorder: :environment do
    require 'resque'

    ENV['QUEUE'] = 'recorder'

    worker = Resque::Worker.new
    worker.log "Starting recorder #{self}"
    worker.work(Settings.recorder.polling_interval || 1) # interval, will block
  end

  desc "Start a Scheduler"
  task scheduler: :environment do
    require 'resque-scheduler'
    ENV['APP_NAME'] = "cocona"
    ENV['RESQUE_SCHEDULER_INTERVAL'] = "1"
    scheduler_cli = Resque::Scheduler::Cli.new
    scheduler_cli.parse_options
    scheduler_cli.setup_env
    Resque.all_schedules.keys.map{|name| Resque.remove_schedule(name)}
    schedule = ActiveScheduler::ResqueWrapper.wrap(Settings.schedule)
    schedule.keys.map do |name|
      schedule[name]['persist'] = "true"
    end
    Resque.schedule = schedule
    scheduler_cli.run_forever
  end

  desc "Epg update"
  task epgupdate: :environment do
    if ENV['CHANNEL'].present?
      channel = Channel.where(name: ENV['CHANNEL']).first
      if channel.blank?
        abort "Channel name: #{ENV['CHANNEL']} is not included in the channel configuration."
      end
      puts "update epg name=#{channel.name} channel=#{channel.channel}"
      epg_update = Cocona::EpgUpdate.new(channel)
      epg_update.exec
    else
      Channel.all.each do |channel|
        puts "update epg name=#{channel.name} channel=#{channel.channel}"
        epg_update = Cocona::EpgUpdate.new(channel)
        epg_update.exec
      end
    end
  end

  desc "Reservation update"
  task reservationupdate: :environment do
    ReservationUpdateJob.perform_now
  end

end
