module Cocona
  class LogFile

    def read(log_type, options = {})
      @log_file_path = type_to_path(log_type)
      offset = options[:offset] || -1
      limit = options[:limit] || 25
      amount = [limit, remaining_lines(offset)].min

      line_index = offset == -1 ? num_lines : offset + amount

      [readlines(amount), line_index]
    end

    private

    def type_to_path(log_type)
      case log_type.intern
      when :web
        filename = "#{Rails.root}/log/web.log"
      end
      return filename
    end

    def remaining_lines(offset)
      offset == -1 ? num_lines : (num_lines - offset)
    end

    def num_lines
      `wc -l #{@log_file_path}`.split.first.to_i
    end

    def readlines(amount)
      `tail -n #{amount} #{@log_file_path}`.split(/\n/)
    end

  end
end
