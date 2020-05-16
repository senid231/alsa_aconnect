# ALSA aconnect

Control ALSA aconnect util through ruby with zero dependency.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alsa_aconnect'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install alsa_aconnect

## Usage

```ruby
require 'alsa/aconnect'

def print_client(client)
  puts "#{client.id} => #{client.name} [type=#{client.type},card=#{client.card},pid=#{client.pid}]"
  client.ports.each do |port|
    if port.connected_to_type
      connected = "connected to #{port.connected_to_type} #{port.connected_to_client_id}:#{port.connected_to_port_id}"
    else
      connected = 'not connected'
    end
    puts "  #{port.id} => #{port.name} (#{connected})"
  end
  puts ''
end

input_clients = ALSA::Aconnect.input_clients
puts "Inputs:"
input_clients.map { |client| print_client(client) }

output_clients = ALSA::Aconnect.output_clients
puts "Outputs:"
output_clients.map { |client| print_client(client) }

input = input_clients.detect { |c| c.name = 'My Input' }.ports.detect { port.name == 'My Input Port' }
output = input_clients.detect { |c| c.name = 'My Output' }.ports.detect { port.name == 'My Output Port' }
ALSA::Aconnect.connect(input, output)

ALSA::Aconnect.disconnect(input, output)

ALSA::Aconnect.connect("#{input.client.id}:#{input.id}", "#{output.client.id}:#{output.id}")
ALSA::Aconnect.disconnect("#{input.client.id}:#{input.id}", "#{output.client.id}:#{output.id}")
```

See more in https://github.com/senid231/alsa_aconnect/blob/master/examples/

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/senid231/alsa_aconnect. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/senid231/alsa_aconnect/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ALSA aconnect project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/senid231/alsa_aconnect/blob/master/CODE_OF_CONDUCT.md).
