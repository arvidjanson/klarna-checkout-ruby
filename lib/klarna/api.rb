require "klarna/api/client"
require "klarna/api/configuration"
require "klarna/api/flags"
require "klarna/api/methods/activate"
require "klarna/api/methods/cancel"
require "klarna/api/methods/credit_invoice"
require "klarna/api/methods/return_amount"

module Klarna
  module Api
    extend Klarna::Api::Configuration
  end
end
