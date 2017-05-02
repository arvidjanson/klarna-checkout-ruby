module Klarna
  module Api
    class Flags

      # Specifies that no flag is to be used.
      NO_FLAG = 0

      ## Gender flags

      # Indicates that the person is a female.<br>
      # Use "" or null when unspecified.<br>
      FEMALE = 0

      # Indicates that the person is a male.<br>
      # Use "" or null when unspecified.<br>
      MALE = 1

      ## Order status constants

      # This signifies that the invoice or reservation is accepted.
      ACCEPTED = 1

      # This signifies that the invoice or reservation is pending, will be set
      # to accepted or denied.
      PENDING = 2

      # This signifies that the invoice or reservation is <b>denied</b>.
      DENIED = 3

      ## Get_address constants

      # A code which indicates that all first names should be returned with the
      # address.
      # Formerly refered to as GA_OLD.
      GA_ALL = 1


      # A code which indicates that only the last name should be returned with
      # the address.
      #
      # Formerly referd to as GA_NEW.
      GA_LAST = 2


      # A code which indicates that the given name should be returned with
      # the address. If no given name is registered, this will behave as
      # GA_ALL.
      GA_GIVEN = 5

      ## Article/goods constants

      # Quantity measured in 1/1000s.
      PRINT_1000 = 1

      # Quantity measured in 1/100s.
      PRINT_100 = 2

      # Quantity measured in 1/10s.
      PRINT_10 = 4

      # Indicates that the item is a shipment fee.
      # Update_charge_amount (1)
      IS_SHIPMENT = 8

      # Indicates that the item is a handling fee.
      # Update_charge_amount (2)
      IS_HANDLING = 16

      # Article price including VAT.
      INC_VAT = 32

      ## Miscellaneous

      # Signifies that this is to be displayed in the checkout.<br>
      # Used for part payment.<br>
      CHECKOUT_PAGE = 0

      # Signifies that this is to be displayed in the product page.<br>
      # Used for part payment.<br>
      PRODUCT_PAGE = 1

      # Signifies that the specified address is billing address.
      IS_BILLING = 100

      # Signifies that the specified address is shipping address.
      IS_SHIPPING = 101

      ## Invoice and Reservation

      # Indicates that the purchase is a test invoice/part payment.
      TEST_MODE = 2

      # PClass id/value for invoices.
      # @see KlarnaPClass::INVOICE.
      PCLASS_INVOICE = -1

      ## Invoice

      # Activates an invoices automatically, requires setting in Klarna Online.

      # If you designate this flag an invoice is created directly in the active
      # state, i.e. Klarna will buy the invoice immediately.
      AUTO_ACTIVATE = 1

      # Creates a pre-pay invoice.
      # @deprecated Do not use.
      PRE_PAY = 8

      # Used to flag a purchase as sensitive order.
      SENSITIVE_ORDER = 1024

      # Used to return an array with long and short ocr number.
      # @see Klarna::addTransaction()
      RETURN_OCR = 8192

      # Specifies the shipment type as normal.
      NORMAL_SHIPMENT = 1

      # Specifies the shipment type as express.
      EXPRESS_SHIPMENT = 2

      ## Mobile (Invoice) flags

      # Marks the transaction as Klarna mobile.
      M_PHONE_TRANSACTION = 262144

      # Sends a pin code to the phone sent in pno.
      M_SEND_PHONE_PIN = 524288

      ## Reservation flags

      # Signifies that the amount specified is the new amount.
      NEW_AMOUNT = 0

      # Signifies that the amount specified is to be added.
      ADD_AMOUNT = 1

      # Sends the invoice by mail when activating a reservation.
      RSRV_SEND_BY_MAIL = 4

      # Sends the invoice by e-mail when activating a reservation.
      RSRV_SEND_BY_EMAIL = 8

      # Used for partial deliveries, this flag saves the reservation number so
      # it can be used again.
      RSRV_PRESERVE_RESERVATION = 16

      # Used to flag a purchase as sensitive order.
      RSRV_SENSITIVE_ORDER = 32

      # Marks the transaction as Klarna mobile.
      RSRV_PHONE_TRANSACTION = 512

      # Sends a pin code to the mobile number.
      RSRV_SEND_PHONE_PIN = 1024

    end
  end
end
