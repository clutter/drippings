module Drippings
  class ProcessJob < ApplicationJob
    queue_as :default

    def perform(scheduling)
      scheduling.with_lock do
        break if scheduling.processed_at?

        resource = scheduling.resource

        process(resource) unless skip?(resource)

        scheduling.touch(:processed_at)
      end
    end

    protected

    def process(_)
      raise NotImplementedError, "Drippings::ProcessJob#process must be defined by a concrete subclass"
    end

    def skip?(resource)
      resource.nil?
    end
  end
end
