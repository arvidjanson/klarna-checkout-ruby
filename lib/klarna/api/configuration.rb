module Klarna
  module Api
    module Configuration
      %w{shared_secret merchant_id country language currency environment}.each do |var|
        define_method("#{var}=") do |attr|
          class_variable_set("@@#{var}".to_sym, attr)
        end

        define_method(var) do
          class_variable_get("@@#{var}".to_sym) rescue nil
        end
      end

      def configure(&blk)
        yield(self)
      end

      def reset!
        self.shared_secret  = nil
        self.merchant_id    = nil
        self.country        = nil
        self.language       = nil
        self.currency       = nil
        self.environment    = :test
      end
    end
  end
end
