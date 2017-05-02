require 'digest'

module Klarna
  module Api
    module Methods
      class Activate

        def self.params(client, rno, optional_info = {})
          [
            client.merchant_id,
            digest(client, rno, optional_info),
            rno,
            optional_info
          ]
        end


        private

        def self.digest(client, rno, optional_info)

          optional_keys = [
            :bclass,
            :cust_no,
            :flags,
            :ocr,
            :orderid1,
            :orderid2,
            :reference,
            :reference_code
          ]

          digest_optional_info = optional_info.values_at(*optional_keys).compact

          if optional_info[:artnos]
            optional_info[:artnos].each do |article|
              digest_optional_info.push article[:artno]
              digest_optional_info.push article[:qty]
            end
          end

          array = [
            client.class::KLARNA_API_VERSION.gsub('.', ':'),
            client.class::VERSION,
            client.merchant_id,
            rno,
            *digest_optional_info,
            client.shared_secret
          ]

          ::Digest::SHA512.base64digest(array.join(':'))
        end

      end
    end
  end
end
