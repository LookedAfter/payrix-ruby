module Payrix
  module Resource
    class Transactions < Base
      include Payrix::ApiAuth
      include Payrix::HttpOperation::Get
      include Payrix::HttpOperation::Post

      TIMEOUT = 90 #seconds

      def initialize(business_id, params={})
        super({}, ATTRS)
        @parent_resource = "businesses/#{business_id}/transactions/"
      end

      ATTRS = [:scope, :response]

      attr_accessor *ATTRS

      def live_tokenized_card_transaction(params, timeout=nil)
        # params = {
        #   "ProcessType": "COMPLETE",
        #   "Reference": "REAL-TIME-TXN-100",
        #   "Description": "This is an example real-time transaction",
        #   "Amount": 100.25,
        #   "CurrencyCode": "AUD",
        #   "CardToken": "cbd86c35289249eb86759453cea4025b",
        #   "ServiceDate": "2022-03-01T10:00:00+10:00",
        #   "Payer": {
        #     "uniqueReference": "A306026D-0B4B-479F-9716-256152C8D310",
        #     "groupReference":"A306026D-0B4B-479F-9716-256152C8D310",
        #     "familyOrBusinessName":"Surname",
        #     "givenName":"First Name",
        #     "billingAddress":{"Line1": "1 Test St","Line2": "Test Building","Suburb": "Testville","State": "QLD","PostCode": "4001","Country": "AUS" },
        #     "email":"test@test.com",
        #     "phone":"0733331111",
        #     "savePayer":"true"
        #   },
        #   "Audit": {
        #     "Username": "Example-User",
        #     "UserIP": "1.2.3.4"
        #   }
        # }
        Payrix::ApiAuth.check_and_login
        @resource_name = @parent_resource + "card-payments/token"
        timeout ||= TIMEOUT
        post(params, timeout)
      end

      def stored_card_transaction(payer_reference, params, timeout=nil)
        # params = {
        #     "ProcessType": "COMPLETE",
        #     "Reference": "Transaction-001",
        #     "Amount": 100.75,
        #     "Description": "This is a test transaction",
        #     "CurrencyCode": "AUD",
        #     "ServiceDate": "2022-03-01T10:00:00+10:00",
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
        resource = @parent_resource.split('transactions/')
        @resource_name = resource[0] + 'payers/' + payer_reference + '/transactions/card'

        timeout ||= TIMEOUT
        post(params, timeout)
      end

      def fraud_check(params)
        # params = {
        #   "Token": "f4111d25-82d3-4743-87f4-cbf7a8e7972f",
        #   "SessionId": "abc12345678901234567890123456789",
        #   "TransactionAmount": 20.78,
        #   "IpAddress": "111.222.333.444",
        #   "Payer": {
        #     "FamilyOrBusinessName": null,
        #     "GivenName": null,
        #     "BillingAddress": null,
        #     "Email": "test@test.com",
        #     "Phone": null
        #   },
        #   "AirlineInfo": null,
        #   "HotelInfo": null,
        #   "CallbackUrl": "https://tester.com.au/test.aspx?p1=asdfasdf&p2=asdfasdf",
        #   "Audit": null
        # }
        Payrix::ApiAuth.check_and_login
        @resource_name = @parent_resource + "card-payments/fraud-check"
        post(params)
      end

      def search_status_changes(params)
        # params = {
        #   "type": 	"Transaction Type", 	 #e.g.: ?type=PDB&type=PDC&type=RT etc.
        #   "status": "Transaction Status",  #e.g.: ?status=C&status=S&status=R etc.)
        #   "source": "Transaction Source",   # Search for transactions initiated via specific sources
        #   "skip": 	"integer", 	#Number of records to not return (offset) when paging results (Default: 0)
        #   "take": 	"integer," 	#Number of records to return per call when paging results (Default: 500)
        # }

        Payrix::ApiAuth.check_and_login
        @resource_name = @parent_resource + "new"
        get(params)
      end

      def acknowledge_status_change(params)
        # params = {
        #   "TransactionId": "121435",
        #   "StatusCode": "C",
        #   "Audit": {
        #     "Username": "Example-User",
        #     "UserIP": "1.2.3.4"
        #   }
        # }
        Payrix::ApiAuth.check_and_login
        @resource_name = @parent_resource + "new"
        post(params)
      end
    end
  end
end
