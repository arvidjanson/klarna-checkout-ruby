require 'xmlrpc/client'

module Klarna
  module Api
    class Client

      VERSION = 'ruby:api:1.1.3'
      KLARNA_API_VERSION = '4.1'
      VALID_ENVS = [:test, :production]

      attr_reader   :merchant_id, :environment
      attr_accessor :shared_secret, :keepalive, :country, :language, :currency

      def initialize(config = {})
        self.merchant_id = Klarna::Api.merchant_id
        self.shared_secret = Klarna::Api.shared_secret
        self.environment = Klarna::Api.environment || :test
        self.keepalive = false
        self.config = config
      end

      def merchant_id=(new_id)
        @merchant_id = new_id.to_i
      end

      def environment=(new_env)
        new_env = new_env.to_sym
        unless VALID_ENVS.include?(new_env)
          raise "Environment must be one of: #{VALID_ENVS.join(', ')}"
        end
        @environment = new_env
      end

      def config=(hash)
        hash.each do |key, value|
          setter = "#{key}="
          self.send(setter, value) if self.respond_to?(setter)
        end
      end

      def activate(rno, optional_info = {})
        unless rno.present?
          raise 'Reservation must be present!'
        end

        defaults = {
          flags: Klarna::Api::Flags::RSRV_SEND_BY_EMAIL
        }

        data = params_list(rno, defaults.merge(optional_info))
        xmlrpc_client.call('activate', KLARNA_API_VERSION, VERSION, *data)
      end


      private

      def xmlrpc_client
        return @xmlrpc_client if @xmlrpc_client

        @xmlrpc_client = XMLRPC::Client.new_from_hash(
          host: host,
          path: '/',
          port: 443,
          use_ssl: true
        )
        @xmlrpc_client.http_header_extra = headers
        @xmlrpc_client
      end

      def params_list(rno, optional_info)
        [
          merchant_id,
          digest(rno, optional_info),
          rno,
          optional_info
        ]
      end

      def digest(rno, optional_info)
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
          KLARNA_API_VERSION.gsub('.', ':'),
          VERSION,
          merchant_id,
          rno,
          *digest_optional_info,
          shared_secret
        ]

        ::Digest::SHA512.base64digest(array.join(':'))
      end

      def host
        if environment == :production
          'payment.klarna.com'
        else
          'payment.testdrive.klarna.com'
        end
      end

      def headers
        @headers = {}
        @headers['Accept-Encoding'] = 'gzip,deflate'
        @headers['Accept-Charset']  = 'UTF-8,ISO-8859-1,US-ASCII'
        @headers['User-Agent']      = "XMLRPC::Client (Ruby #{RUBY_VERSION})"
        @headers['Content-Type']    = 'text/xml; charset=ISO-8859-1'
        @headers['Connection']      = 'close' unless keepalive
        @headers
      end
    end
  end
end
