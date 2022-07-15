# Payrix::Ruby

It is based on [Payrix Rest API](https://docs.rest.paymentsapi.io/) built for our project. It has not included all the APIs. Below are API included:
* Authorizing Your Request
  - POST - Login

* BPAY
  - GET Payers CRN
  - POST A CRN to an existing Payer
  - POST Assing new CRN

* Business Details
  - GET Your business details

* Payers
  - Add and Edit Payer
    + POST Add a new Payer
    + PUT Update an existing Payer
    + PUT Add or update a Payers card details
    + POT Add or update a Payers card details via token
  - Delete a Payer
    + DEL Remove a Payers payment methods
  - Search Payer Details
    + GET Look up a Payer payment options

* Transactions
  - Create Card Transaction
    + POST Make a live tokenized card transaction
  - Saved Card Transaction
    + POST Process a transaction using saved card details
  - Status Changes
    + GET Search for transaction status changes
    + POST Acknowledge transaction status change
  - Refund transaction
    + POST Refund bank transaction

Add new API into `lib/payrix/resource` directory.


Flow
Once you provide API `username` and `userkey` at configuration. At Every call of api it will check the authentication and login using `POST - Login` if token is expired or not found.

There are no test coverage written for gem.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'payrix-ruby', git: 'https://github.com/LookedAfter/payrix-ruby', require: 'payrix'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install payrix-ruby

## Usage
```
Payrix.configure(sandbox: true) do |config|
  config.log_level = :debug
  config.api_username = <API_USERNAME>
  config.api_userkey = <API_USERKEY>
end
```
```
b=Payrix::Resource::Businesses.new({})
if b.status(<Business Id>)
  b.response.body # Success Response Type
else
  b.response.body # Error Response Type
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/payrix-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Payrix::Ruby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/payrix-ruby/blob/master/CODE_OF_CONDUCT.md).
