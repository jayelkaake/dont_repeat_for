# Don't Repeat For Gem

Runs a block only once in the given time frame and lets you make sure it doesn't repeat more than the times you specify per time block. 

Uses redis to know if we've run the block before.

### Why?
Sometimes you don't want to flood your logs with repeated messages, or you want to make sure notifications are not send multiple times to your messaging groups.

**Table of Contents**
* [Installation](#installation)
* [Usage](#usage)
* [Other Things](#Other_Things)

# Installation
Add this line to your application's Gemfile:
```ruby
gem 'dont_repeat_for'
```
And then execute:
    $ bundle
Or install it yourself as:
    $ gem install dont_repeat_for

### Requirements
Requires `redis` to be available and installed. That's what it will use for memory.


# Usage
```ruby
  ##
  # @param time [Integer] The amount of seconds that we don't want to repeat the process for
  # @param key [String]  A unique key to identify the process that we don't want to repeat for the given time
  def initialize(time, key)
```

### Example 1: Global Key

```ruby
20.times do
  DontRepeatFor.new("Everyone/Test", 1.second) { puts "This message will only be displayed once every 1 second."; }
end
sleep(1.second)
DontRepeatFor.new("Everyone/Test", 1.second) { puts "This message will only be displayed once every 1 second."; }

# Output:
# This message will only be displayed once every 1 second.
# This message will only be displayed once every 1 second.
```

### Example 2: User Key

```ruby
user1 = User.new(id: -1)
user2 = User.new(id: -2)
20.times do
  DontRepeatFor.new("User-#{user1.id}/Test", 1.second) { puts "This message will only be displayed once every 1 second for user #{user1.id}."; }
  DontRepeatFor.new("User-#{user2.id}/Test", 1.second) { puts "This message will only be displayed once every 1 second for user #{user2.id}."; }
end
sleep(1.second)
DontRepeatFor.new("User-#{user1.id}/Test", 1.second) { puts "This message will only be displayed once every 1 second for user #{user1.id}."; }
DontRepeatFor.new("User-#{user2.id}/Test", 1.second) { puts "This message will only be displayed once every 1 second for user #{user2.id}."; }

# Output:
# This message will only be displayed once every 1 second for user -1.
# This message will only be displayed once every 1 second for user -2.
# This message will only be displayed once every 1 second for user -1.
# This message will only be displayed once every 1 second for user -2.
```

# Other Things
### Roadmap
* Make this system compatible with memory-baseds storage and other data storage systems.

### Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/jayelkaake/dont_repeat_for.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

### License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
