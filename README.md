# Garden Rails

Generate YARD docs for the parts of your Rails project that intellisense tools normally struggle with (ActiveModel attributes and associations). This project was started with the intention of helping [Solargraph](https://solargraph.org) to work better with Rails.

Acknowledgement: this project is heavily influenced by https://gist.github.com/hellola/b832cff599f67a5e353e6af4914d467a

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'garden_rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install garden_rails

## Usage

Run `rake garden_rails:generate`

This will generate one file for each of your models in config/yard (TODO: make this configurable) with YARD directives describing their attributes and associations.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iftheshoefritz/garden_rails.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
