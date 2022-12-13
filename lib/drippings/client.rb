module Drippings
  class Client
    Drip = Struct.new(:job, :scope, :wait_until, :time_zone, :options)

    def initialize
      @drips = {}
    end

    def kickoff
      @drips.each do |name, _|
        ScheduleJob.perform_later(name)
      end
    end

    def schedule(name)
      drip = @drips[name]
      scope = drip.scope.call
      job = drip.job
      raw_wait_until = drip.wait_until
      time_zone = drip.time_zone

      Scheduling.dedup(scope, name).find_in_batches do |batch|
        batch.each do |resource|
          scheduling = Drippings::Scheduling.create!(name: name, resource: resource)
          wait_until = raw_wait_until.present? ? wait_until(resource, raw_wait_until, time_zone) : nil
          job.set(wait_until: wait_until).perform_later(scheduling, **drip.options)
        end
      end
    end

    def register(name, job, scope, wait_until: nil, time_zone: nil, options: {})
      raise ArgumentError, "A drip has already been registered for #{name}" if @drips[name].present?
      raise ArgumentError, 'Job must be a subclass of Drippings::ProcessJob' unless job < Drippings::ProcessJob
      if wait_until.present? && time_zone.nil?
        raise ArgumentError, 'time_zone must be defined if providing a wait_until'
      end

      @drips[name] = Drip.new(job, scope, wait_until, time_zone, options)
    end

    private

    def wait_until(resource, wait_until, time_zone)
      tz = time_zone.call(resource)
      time = Time.current.in_time_zone(tz).change(wait_until)
      time += 1.day if time.past?
      time
    end
  end
end
