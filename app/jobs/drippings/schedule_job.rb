module Drippings
  class ScheduleJob < ApplicationJob
    queue_as :default

    def perform(name)
      Drippings.client.schedule(name)
    end
  end
end
