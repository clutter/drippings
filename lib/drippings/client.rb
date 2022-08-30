module Drippings
  class Client
    Drip = Struct.new(:job, :scope, :args, :kwargs)

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

      Scheduling.dedup(scope, name).find_in_batches do |batch|
        batch.each do |resource|
          scheduling = Drippings::Scheduling.create!(name: name, resource: resource)
          job.perform_later(scheduling, *drip.args, **drip.kwargs)
        end
      end
    end

    def register(name, job, scope, *args, **kwargs)
      raise ArgumentError, "A drip has already been registered for #{name}" if @drips[name].present?
      raise ArgumentError, 'Job must be a subclass of Drippings::ProcessJob' unless job < Drippings::ProcessJob

      @drips[name] = Drip.new(job, scope, args, kwargs)
    end
  end
end
