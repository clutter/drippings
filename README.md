# Drippings
Short description and motivation.

## Usage
To define a drip, create a subclass of `Drippings::ProcessJob` which implements `process`. For example:

```ruby
class LeadFollowupJob < Drippings::ProcessJob
  
  # @param lead [Lead] the lead to email
  def process(lead)
    MessageSenderService.send(body: 'Hello, buy my product!', lead: lead)
  end
end
```

To define the schedule on which you want your drips to process, register a drip by defining a
drip name, process job, and scope:

```ruby
# config/initializers/drippings.rb
Drippings.configure do |config|
  config.register("Lead::Followup", LeadFollowupJob, -> { Lead.active })
end
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'drippings'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install drippings
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
