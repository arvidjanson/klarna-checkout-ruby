require 'digest'

module Klarna
  module Api
    module Methods
      class Cancel

        def self.params(client, rno)
          [
            rno,
            client.merchant_id,
            digest(client, rno)
          ]
        end


        private

        def self.digest(client, rno)
          array = [
            client.merchant_id,
            rno,
            client.shared_secret
          ]

          ::Digest::SHA512.base64digest(array.join(':'))
        end

      end
    end
  end
end
