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

        params = Klarna::Api::Methods::Activate.params(self, rno, defaults.merge(optional_info))
        xmlrpc_client.call('activate', KLARNA_API_VERSION, VERSION, *params)
      end

      def cancel(rno)
        unless rno.present?
          raise 'Reservation must be present!'
        end

        params = Klarna::Api::Methods::Cancel.params(self, rno)
        xmlrpc_client.call('cancel_reservation', KLARNA_API_VERSION, VERSION, *params)
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
