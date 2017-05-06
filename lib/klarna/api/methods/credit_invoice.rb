require 'digest'

module Klarna
  module Api
    module Methods
      class CreditInvoice

        def self.params(client, ino)
          [
            client.merchant_id,
            ino,
            ino,
            digest(client, ino),
          ]
        end


        private

        def self.digest(client, ino)
          array = [
            client.merchant_id,
            ino,
            client.shared_secret
          ]

          ::Digest::SHA512.base64digest(array.join(':'))
        end

      end
    end
  end
end
