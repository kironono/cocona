require "open3"

module Cocona
  class Capture

    attr_reader :cmd
    attr_reader :channel, :sid
    attr_reader :end_at
    attr_reader :store_path

    def initialize(cmd:, channel:, sid:, end_at:, store_path:)
      unless end_at.is_a?(Time)
        raise ArgumentError.new "'end_at' only Time are allowed"
      end
      @cmd = cmd
      @channel = channel
      @sid = sid
      @end_at = end_at
      @store_path = store_path
    end

    def logger
      @logger ||= Rails.logger
    end

    def exec
      logger.info "Start capture..."
      logger.debug "channel: #{@channel}"
      logger.debug "sid: #{@sid}"
      logger.debug "end_at:   #{@end_at}"
      logger.debug "store_path: #{@store_path}"

      store_file = File.open(@store_path, "wb")

      logger.debug "Execute command: #{capture_command}"
      Open3.popen3(capture_command) do |stdin, stdout, stderr, wait_thr|
        stdin.close_write

        stdout_thr = Thread.new do
          begin
            until stdout.eof?
              data = stdout.read_nonblock(1024)
              store_file.write(data)
              store_file.flush
            end
          rescue EOFError => e
            logger.debug "EOF: #{e}"
          rescue => e
            logger.error e
            logger.error e.backtrace.join("\n")
            stdout.close
          end
        end

        stderr_thr = Thread.new do
          begin
            until stderr.eof?
              data = stderr.readline
              data = data.chomp
              logger.info "STDERR> #{data}"
            end
          rescue EOFError => e
          rescue => e
            logger.error e
            logger.error e.backtrace.join("\n")
            stderr.close
          end
        end

        t = Thread.new do
          begin
            loop do
              if Time.now > @end_at
                logger.info "Reached the end time: #{@end_at}"
                5.times {|v|
                  begin
                    live = Process.kill 0, wait_thr.pid
                    logger.info "Stopping process pid: #{wait_thr.pid} (#{v + 1}/5)..."
                    Process.kill(:TERM, wait_thr.pid)
                  rescue Errno::ESRCH
                    logger.info "Stopped process pid: #{wait_thr.pid}"
                    break
                  end
                  sleep 1
                }
                break
              end
              sleep 1
            end
          rescue => e
            logger.error e
            logger.error e.backtrace.join("\n")
            Process.kill("KILL", wait_thr.pid)
          end
        end

        wait_thr.join
        t.join
      end

      store_file.close unless store_file.closed?
      logger.info "Finished capture!"
      return true
    end

    private

    def capture_command
      return @cmd.gsub(/{{sid}}/, @sid.to_s).gsub(/{{channel}}/, @channel.to_s).strip
    end

  end
end
