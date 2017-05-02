require 'digest'

module Klarna
  module Api
    class Activate

      # Activates the order in klarna.
      #
      # optional_info structure
      #
      # Variable        Type      Description
      # -------------------------------------------------------------------------
      # orderid1        string    Order ID #1
      #
      # orderid2        string    Order ID #2
      #
      # flags           integer   4: Send the invoice by mail
      #                           8: Send the invoice by e-mail
      #                           512: "Klarna Mobil" transaction
      #
      # reference       string    The reference person for the purchase if it is
      #                           a company purchase. You can also use reference
      #                           variable to write a message or other important
      #                           information to the consumer on the invoice.
      #
      # reference_code  string    The reference code for the sale. You can also
      #                           use reference_code variable to write a message
      #                           or other important information to the consumer
      #                           on the invoice.
      #
      # ocr             string    The payment reference number which the consumer
      #                           will use to pay Klarna. Please ask for more
      #                           information from your integration sales contact.
      #
      # pin             string    Consumer’s PIN code when using “Klarna Mobil”
      #                           service
      #
      # artnos          hash      Used if you want to activate a part of an order.
      #                           See Artnos structure below for more information.
      #
      # shipping_info   hash      Used to send information about shipment like
      #                           tracking numbers. See shipment_info structure
      #                           below for more information.
      #
      #
      # artnos structure
      #
      # Variable  Type      Description
      # -----------------------------------------------------------
      # artno     string    Article number on item to be activated
      # qty       integer   Number of items to activate
      #
      #
      # TODO: shipment_info structure
      #
      # @see https://developers.klarna.com/en/api-references-v1/manage-orders#activate
      #
      # @param [Klarna::Api::Client] client
      # @param [String] rno - Klarna order reservation number
      # @param [Hash] optional_info
      #
      #
      # @return [Array] [risk_status, invoice_number]
      #
      # risk_status - This represents the risk status and can have two values:
      #
      #   OK -      this response means that the order has passed Klarna’s fraud
      #              and credit assessment
      #   no_risk - this response means that Klarna will not assume the fraud
      #             risk for this order
      #
      # invoice_number - This number represents the invoice number in Klarna’s
      #                  system and should be used in all subsequent order
      #                  handling calls.
      #
      #
      # @raise [XMLRPC::FaultException] FaultException has two accessor-methods
      #                                 faultCode an Integer, and faultString a
      #                                 String.
      #
      def self.params_list(client, rno, optional_info = {})
        [
          client.merchant_id,
          digest(client, rno, optional_info),
          rno,
          optional_info
        ]
      end

      private

      # Digest
      #
      # Build digest. Any field in optional_info that is set is included in
      # the digest.
      #
      # Consist of all values from the variables which you send in the call
      # separated with a colon without the square brackets. Variables in
      # parentheses are optional.
      # If you are not sending a variable, remove that from the digest. Shared
      # secret must be the last variable.
      #
      # Example:
      #   base64encode(sha512("4:1:[client_vsn]:[eid]:[rno]:[flags](:[orderid1])
      #         (:[orderid2])(:[referece])(:[reference_code]):[shared_secret]"))
      #
      # @param [Klarna::Api::Client] client
      # @param [String] rno
      # @param [Hash] optional_info
      #
      # @return [String] digest
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
