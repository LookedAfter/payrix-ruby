module Payrix
  module Resource
    class Bpay < Base
      include Payrix::ApiAuth
      include Payrix::HttpOperation::Get
      include Payrix::HttpOperation::Post

      def initialize(business_id, params={})
        super({}, ATTRS)
        @parent_resource = "businesses/#{business_id}/"
      end

      ATTRS = [:scope, :response]

      attr_accessor *ATTRS

      def payer_crn(payer_reference)
        if !payer_reference
          if Payrix.configuration.exception_enabled
            raise Payrix::InvalidRequestError.new('Payer reference is required.')
          else
            return false
          end
        end

        Payrix::ApiAuth.check_and_login
        @resource_name =  @parent_resource + 'payers/' + payer_reference + '/accounts/bpay'
        get()
      end

      def assing_crn_to_payer(payer_reference)
        if !payer_reference
          if Payrix.configuration.exception_enabled
            raise Payrix::InvalidRequestError.new('Payer reference is required.')
          else
            return false
          end
        end

        Payrix::ApiAuth.check_and_login
        @resource_name =  @parent_resource + 'payers/' + payer_reference + '/accounts/bpay'
        post()
      end

      def all_crns(params)
        # BillerCode 	string 	BPAY Biller Code
        # CRN 	string 	BPAY Unique Customer Reference Number (CRN)
        # Reference 	string 	Unique reference for identifying the BPAY CRN assignment request
        # Description 	string 	Description of the purpose of the CRN
        # PayerReference 	string 	Your unique reference associated with a Payer
        # InvoiceType 	BPAY Invoice Type 	Integrated accounting system invoice type
        # InvoiceId 	string 	The acocunting system's unique reference/id for an invoice
        # InvoiceReference 	string 	The reference to identify the invoice being paid within your systems
        # Amount 	decimal 	iCRNs Only - the amount the iCRN was restricted to
        # ExpiryDate 	Date/Time 	iCRNs Only - the due date the iCRN was restricted to
        # Skip 	integer 	Number of records to not return (offset) when paging results (Default: 0)
        # Take 	integer 	Number of records to return per call when paging results (Default: 200)
        Payrix::ApiAuth.check_and_login
        @resource_name =  @parent_resource + 'bpay'
        get(params)
      end

      def assing_new_crn(params)
        # params = {
        #   "Reference":"a01264a4-09b0-41e9-bfa9-5e58690fda63",
        #   "Description":"Description of BPay reference",
        #   "PayerReference":"P13-UNIQUE-REF",
        #   "InvoiceType": "XERO",
        #   "InvoiceId":"b5c45415-6910-4619-bd1d-762ac949ddc4",
        #   "InvoiceReference":"99f82591-4173-41b2-8336-5ab963f9a820",
        #   "restrictToAmount":"300.00",
        #   "restrictToDueDate":"2019-11-18T22:00:00.00",
        #   "Audit":
        #     {
        #     "Username":"YourApiUsername",
        #     "UserIP":"YourIPAddress"
        #   }
        # }
        Payrix::ApiAuth.check_and_login
        @resource_name =  @parent_resource + 'bpay'
        post(params)
      end
    end
  end
end
