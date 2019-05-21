require "dont_repeat_for/version"

##
# Runs a block only once in the given time frame
# Uses redis to know if we've run the block before.
# Example 1:
# ```ruby
#   20.times do
#     DontRepeatFor.new("test_dont_repeat/test", 5.minutes) { puts "This message will only be displayed once every 5 minutes.";
#     sleep(1.minute)
#   end
# ```
#
# @hint: You can include an ID in the key to enforce rate limiting for a specific store.
class DontRepeatFor
  attr_accessor :key, :time

  ##
  # @param time [Integer] The amount of seconds that we don't want to repeat the process for
  # @param key [String]  A unique key to identify the process that we don't want to repeat for the given time
  def initialize(time, key)
    @key = key
    @time = time.to_i

    return nil if ran_recently?

    remember_not_to_repeat!

    yield
  end

  private

  def remember_not_to_repeat!
    redis.set(storage_key, true, ex: time)
  end

  def ran_recently?
    redis.get(storage_key)
  end

  def storage_key
    @storage_key ||= "DontRepeatFor/Keys/#{@key}"
  end

  def redis
    return $redis if defined?($redis)

    self.class.redis
  end

  def self.redis
    @redis ||= Redis.new
  end
end

