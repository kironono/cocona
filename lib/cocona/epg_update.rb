require "open3"

module Cocona
  class EpgUpdate

    attr_reader :channel

    def initialize(channel)
      @channel = channel
    end

    def logger
      @logger ||= Rails.logger
    end

    def exec
      end_at = Time.now + Settings.epg_update.duration.to_i.seconds
      tempdir = File.join(Settings.directory.temporary, 'epg_update')
      tempfile = File.join(tempdir, "#{@channel.name}_#{SecureRandom.hex(10)}.m2ts")
      unless File.directory?(tempdir)
        FileUtils.mkdir_p(tempdir)
      end

      begin
        capture_ret = capture(end_at, tempfile)
        return false unless capture_ret
        epg_data = parse_epg_data(tempfile)
        return false unless epg_data.present?
        update_programs(epg_data)
      ensure
        if File.exist?(tempfile)
          File.delete(tempfile)
          logger.debug "Delete tempfile: #{tempfile}"
        end
      end
    end

    private
    def capture(end_at, tempfile)
      logger.debug "Epg update name: #{@channel.name} channel: #{@channel.channel}"
      logger.debug "tempfile: #{tempfile}"
      capture = Capture.new(
        cmd: Settings.recorder.command,
        channel: @channel.channel,
        sid: 'epg',
        end_at: end_at,
        store_path: tempfile
      )
      return capture.exec
    end

    def parse_epg_data(tempfile)
      logger.debug "Parse EPG data"
      parse_command = "#{Settings.epg_update.command} json #{tempfile} -"
      stdout, stderr, status = Open3.capture3(parse_command)
      if status != 0
        logger.error "Parse error: #{stderr}"
        return nil
      end
      return JSON.parse(stdout, {symbolize_names: true})
    end

    def update_programs(epg_data)
      ActiveRecord::Base.transaction do
        epg_data.each do |service_data|
          service_id = service_data[:service_id]
          service_name = service_data[:name]
          cs = upsert_channel_service(service_id, service_name)
          if service_data[:programs]
            service_data[:programs].each do |program_data|
              upsert_program(cs, program_data)
            end
          end
        end
      end
    end

    def upsert_channel_service(service_id, service_name)
      cs = ChannelService.where(channel_id: @channel.id, service_id: service_id).first
      if cs.blank?
        cs = ChannelService.new({channel_id: @channel.id, service_id: service_id, name: service_name})
        cs.save!
      end
      if cs.name != service_name
        cs.name = service_name
        cs.save!
      end
      return cs
    end

    def upsert_program(cs, program_data)
      event_id = program_data[:event_id]
      program = Program.where("start_at >= ?", Time.now - 24.hours)
        .where(event_id: event_id, channel_service_id: cs.id)
        .first
      if program.blank?
        program = Program.new({
          channel_id: @channel.id,
          channel_service_id: cs.id,
          event_id: event_id
        })
      end

      program.attributes = program_data_to_program_update_params(program_data)
      program.save!
    end

    def program_data_to_program_update_params(program_data)
      start_at = Time.at(program_data[:start].to_i / 10000)
      end_at = Time.at(program_data[:end].to_i / 10000)
      sub_categories = find_categories(program_data[:category])
      params = {
        title: program_data[:title],
        detail: program_data[:detail],
        ext_detail: program_data[:extdetail].map{|node| "#{node[:item_description]}\n#{node[:item]}"}.join("\n\n"),
        start_at: start_at,
        end_at: end_at,
        duration: program_data[:duration].to_i,
        video: program_data[:video].to_json,
        audio: program_data[:audio].to_json,
        sub_categories: sub_categories,
      }
      return params
    end

    def find_categories(category_data)
      categories = []
      category_data.each do |node|
        category = SubCategory.joins(:main_category) \
          .where("main_categories.name = ?", node[:large][:ja_JP]) \
          .where(name: node[:middle][:ja_JP]).first
        categories << category if category.present?
      end
      return categories
    end

  end
end
