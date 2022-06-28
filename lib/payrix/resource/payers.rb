module Payrix
  module Resource
    class Payers < Base
      include Payrix::ApiAuth
      include Payrix::HttpOperation::Get
      include Payrix::HttpOperation::Post
      include Payrix::HttpOperation::Put
      include Payrix::HttpOperation::Delete

      def initialize(business_id, params={})
        super({}, ATTRS)
        @resource_name = "businesses/#{business_id}/payers/"
      end

      ATTRS = [:scope, :response]

      attr_accessor *ATTRS

      def add(params)
        # parmas = {
        #     "UniqueReference": "P1-UNIQUE-REF",
        #      "GroupReference": "P1-UNIQUE-REF",
        #      "FamilyOrBusinessName": "Citizen",
        #      "GivenName": "Jane",
        #      "Email": "CustomerIntegration@payrix.com.au",
        #      "Phone": "0733332222",
        #      "Mobile": "0411228833",
        #      "Address": {
        #        "Line1": "1 Test St",
        #        "Line2": "Test Bulding",
        #        "Suburb": "Testville",
        #        "State": "QLD",
        #        "PostCode": "4001",
        #        "Country": null
        #    },
        #    "DateOfBirth": "1970-10-31",
        #    "ExtraInfo": {
        #      "XeroAutoDebitEnabled": false
        #    },
        #    "Audit": {
        #      "Username": "Example-User",
        #      "UserIP": "1.2.3.4"
        #    }
        #  }
        Payrix::ApiAuth.check_and_login
        post(params)
      end

      def update(payer_reference, params)
        @resource_name = @resource_name + "#{payer_reference}/"

        if !payer_reference
          if Payrix.configuration.exception_enabled
            raise Payrix::InvalidRequestError.new('Payer reference is required.')
          else
            return false
          end
        end
        Payrix::ApiAuth.check_and_login
        put(params)
      end

      def card_details(payer_reference, params)
        # Add or update payers card details
        # payer_reference => uniq payer idtentifier in your system
        # params = {
        #     "CardNumber": "4111111111111111",
        #     "CardholderName": "TEST CARD",
        #     "ExpiryYear": 2027,
        #     "ExpiryMonth": 11,
        #     "Ccv": null,
        #     "Audit": {
        #       "Username": "Example-User",
        #       "UserIP": "1.2.3.4"
        #     }
        # }
        if !payer_reference
          if Payrix.configuration.exception_enabled
            raise Payrix::InvalidRequestError.new('Payer reference is required.')
          else
            return false
          end
        end

        Payrix::ApiAuth.check_and_login
        @resource_name = @resource_name + "#{payer_reference}/accounts/card"
        put(params)
      end

      def card_token(payer_reference, params)
        # Add card details via token, use webpage to get token if no  PCI complaince
        # payer_reference => uniq payer idtentifier in your system
        # params = {
        #   "CardToken": "59ceb5f71800406285b9d9543a9f40fe",
        #   "Audit": {
        #     "Username": "Example-User",
        #     "UserIP": "1.2.3.4"
        #     }
        # }
        if !payer_reference
          if Payrix.configuration.exception_enabled
            raise Payrix::InvalidRequestError.new('Payer reference is required.')
          else
            return false
          end
        end
        Payrix::ApiAuth.check_and_login
        @resource_name = @resource_name + "#{payer_reference}/accounts/card/token"
        post(params)
      end

      def remove(payer_reference, params={})
        # optional
        # params = {
        #   "Audit": {
        #     "Username": "Example-User",
        #     "UserIP": "1.2.3.4"
        #    }
        # }
        if !payer_reference
          if Payrix.configuration.exception_enabled
            raise Payrix::InvalidRequestError.new('Payer reference is required.')
          else
            return false
          end
        end
        Payrix::ApiAuth.check_and_login
        @resource_name = @resource_name + "#{payer_reference}/accounts"
        delete(params)
      end

      def search_payment_options(payer_reference)
        if !payer_reference
          if Payrix.configuration.exception_enabled
            raise Payrix::InvalidRequestError.new('Payer reference is required.')
          else
            return false
          end
        end
        Payrix::ApiAuth.check_and_login
        @resource_name = @resource_name + "#{payer_reference}/accounts"
        get()
      end
    end
  end
end
