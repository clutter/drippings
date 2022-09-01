# Drippings
Drippings is a gem used to quickly create drip campaigns within rails apps without boilerplate de-duping logic

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

`ProcessJob` subclasses can also accept any ad hoc arguments you may need:

```ruby
class LeadFollowupJob < Drippings::ProcessJob
  
  # @param lead [Lead] the lead to email
  def process(lead, phone:, transactional:)
    MessageSenderService.send(
      body: 'Hello, buy my product!',
      lead: lead,
      phone: phone,
      transactional: transactional
    )
  end
end
```

To define the schedule on which you want your drips to process, register a drip by defining a
drip name, process job subclass, scope, and any additional arguments you want to pass via `options`:

```ruby
# config/initializers/drippings.rb
Drippings.configure do |config|
  config.register(
    "Lead::Followup",
    LeadFollowupJob,
    -> { Lead.active },
    options: {
      phone: '555-555-5555',
      transactional: true,
    }
  )
end
```

You can also define a time to send your messages by defining a
`wait_until` (formatted as a hash of time units) and a `time_zone`, which
can either be a proc do determine a timezone per resource, or a string to define
a timezone for all resources:

```ruby
Drippings.configure do |config|
  config.register(
    "Lead::Followup",
    LeadFollowupJob,
    -> { Lead.active },
    wait_until: { hour: 16 }, # 4PM
    time_zone: ->(lead) { lead.time_zone },
    options: {
      phone: '555-555-5555',
      transactional: true,
    }
  )
end
```

Finally, add the `Drippings::Kickoff` job to your recurring job scheduler, such as sidekiq-scheduler

```yml
# sidekiq.yml
drippings_kickoff_job:
    cron: '*/15 * * * * UTC'
    class: Drippings::KickoffJob
    enabled: false
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

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
