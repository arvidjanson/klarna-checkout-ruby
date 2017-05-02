require "klarna/api/client"
require "klarna/api/configuration"
require "klarna/api/flags"
require "klarna/api/methods/activate"
require "klarna/api/methods/cancel"

module Klarna
  module Api
    extend Klarna::Api::Configuration
  end
end
