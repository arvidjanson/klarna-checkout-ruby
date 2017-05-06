require 'digest'

module Klarna
  module Api
    module Methods
      class ReturnAmount

        def self.params(client, ino, amount, vat, optional_info = {})
          [
            client.merchant_id,
            ino,
            amount,
            vat,
            digest(client, ino),
            Klarna::Api::Flags::INC_VAT,
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
