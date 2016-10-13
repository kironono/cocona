require "open3"

class PlayersController < ApplicationController
  # include ActionController::Live

  before_action :set_video, only: [:show, :play]

  def show
  end

  def play
    duration = @video.duration
    args = []
    videodir = File.join(Settings.directory.recorded)
    videofile = File.join(videodir, @video.store_path)

    # input
    args << ["-i", "\"#{videofile}\""]

    # start sec
    args << ["-ss", 2.to_s]

    # codecs
    args << ["-c:v", "libx264"]
    args << ["-c:a", "aac"]

    # filters
    args << ["-filter:v", "yadif"]

    # libx264 option
    args << ["-profile:v", "baseline"]
    args << ["-preset", "ultrafast"]
    args << ["-tune", "fastdecode,zerolatency"]

    # mp4 option
    args << ["-movflags", "frag_keyframe+empty_moov+faststart+default_base_moof"]

    args << ["-f", "mp4"]
    args << ["pipe:1"]

    cmd = "/home/cocona/src/ffmpeg-3.1.1-64bit-static/ffmpeg #{args.flatten.join(' ')}"

    render :nothing
  rescue => e
    logger.error e
    logger.error e.backtrace.join("\n")
    raise e
  end

  class FFMpegStream
    attr_reader :command

    def initialize(command)
      @command = command
      logger.info "start #{command} -------------------------------------"
    end

    def logger
      @logger ||= Rails.logger
    end

    def each
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        stdin.close_write

        stderr_thr = Thread.new do
          begin
            until stderr.eof?
              data = stderr.readline.chomp
              logger.info "STDERR> #{data}"
            end
          rescue EOFError => e
          rescue => e
            logger.error e
            logger.error e.backtrace.join("\n")
            stderr.close
          end
        end

        begin
          until stdout.eof?
            data = stdout.read(1024)
            yield data
          end
        rescue EOFError => e
          logger.error e
        rescue => e
          logger.error e
          logger.error e.backtrace.join("\n")
          stdout.close
        end

        wait_thr.join
      end
      logger.info "end #{command} -------------------------------------"
    end

  end

  private
  def set_video
    @video = Video.find(params[:id])
  end

end
