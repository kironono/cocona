class LogStreamChannel < ApplicationCable::Channel

  def subscribed
    stream_from "log_stream"
  end

  def read_nextlines(data)
    reader = Cocona::LogFile.new
    options = {
      offset: data['offset'],
      limit: data['limit']
    }
    lines, line_index = reader.read(data['log_type'], options = options)
    ActionCable.server.broadcast 'log_stream', {lines: lines, line_index: line_index}
  end

end
