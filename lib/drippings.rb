require "drippings/version"
require "drippings/engine"
require "drippings/client"

module Drippings
  def self.client
    @client ||= Drippings::Client.new
  end

  def self.configure
    yield client
  end
end
