module Drippings
  class ScheduleJob < ApplicationJob
    queue_as :default

    # @param name [String]
    def perform(name)
      Drippings.client.schedule(name)
    end
  end
end
