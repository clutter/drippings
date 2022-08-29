module Drippings
  class KickoffJob < ApplicationJob
    queue_as :default

    def perform
      Drippings.client.kickoff
    end
  end
end
