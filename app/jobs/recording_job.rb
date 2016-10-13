class RecordingJob < ApplicationJob
  queue_as :recorder

  def perform(message)
    logger.debug message
    options = JSON.parse(message, {symbolize_names: true})
    reservation = Reservation.where(id: options[:reservation_id], status: :standby).first
    unless reservation.present?
      logger.debug "reservation not found id: #{options[:reservation_id]}"
    end

    program = reservation.program

    videodir = File.join(Settings.directory.recorded)
    relative_videofile = "#{reservation.id}_#{program.event_id}_#{program.title}.m2ts"
    videofile = File.join(videodir, relative_videofile)
    unless File.directory?(videodir)
      FileUtils.mkdir_p(videodir)
    end

    # wait start time
    loop do
      start_wait_time = Time.now - program.start_at
      if start_wait_time > -1.second
        break
      end
      logger.debug "Waiting start (#{program.start_at}) #{start_wait_time.to_i * -1} seconds..."
      sleep 1
    end

    capture = Cocona::Capture.new(
      cmd: Settings.recorder.command,
      channel: program.channel.channel,
      sid: program.channel_service.service_id,
      end_at: program.end_at,
      store_path: videofile,
    )

    # notify recording start
    begin
      Cocona::Notificators::RecordingStartNotificator.new(program).notify
    rescue => e
      logger.error e
      logger.error e.backtrace.join("\n")
    end

    reservation.status = :recording
    reservation.save!

    capture.exec

    video = Video.new({
      channel: program.channel.channel,
      service_id: program.channel_service.service_id,
      service_name: program.channel_service.name,
      event_id: program.event_id,
      title: program.title,
      detail: program.detail,
      ext_detail: program.ext_detail,
      start_at: program.start_at,
      end_at: program.end_at,
      duration: program.duration,
      video: program.video,
      audio: program.audio,
      store_path: relative_videofile,
      sub_categories: program.sub_categories,
    })
    video.save!

    reservation.status = :recorded
    reservation.save!

    # notify recording finish
    begin
      Cocona::Notificators::RecordingFinishNotificator.new(program).notify
    rescue => e
      logger.error e
      logger.error e.backtrace.join("\n")
    end
  rescue => e
    logger.error e
    logger.error e.backtrace.join("\n")
    if reservation.present?
      reservation.status = :recorded
      reservation.save!
    end
  end

end
