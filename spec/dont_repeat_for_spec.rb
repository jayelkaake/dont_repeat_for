RSpec.describe DontRepeatFor do
  let(:fake_redis) { FakeRedis.new }

  around do |example|
    old_redis = $redis if defined?($redis)
    was_defined = defined?($redis)
    $redis = fake_redis
    fake_redis.reset!
    example.run
  ensure
    if was_defined
      $redis = old_redis
    else
      $redis = nil
    end
  end

  describe "VERSION" do
    it "is defined" do
      expect(DontRepeatFor::VERSION).to be_a(String)
    end
  end

  describe "#initialize" do
    it "executes the block the first time" do
      executed = false
      DontRepeatFor.new(300, "test/first_run") { executed = true }
      expect(executed).to be true
    end

    it "does not execute the block on a second call with the same key" do
      call_count = 0
      2.times { DontRepeatFor.new(300, "test/duplicate") { call_count += 1 } }
      expect(call_count).to eq(1)
    end

    it "does not execute the block on any subsequent calls with the same key" do
      call_count = 0
      5.times { DontRepeatFor.new(300, "test/many") { call_count += 1 } }
      expect(call_count).to eq(1)
    end

    it "executes blocks with different keys independently" do
      results = []
      DontRepeatFor.new(300, "test/a") { results << :a }
      DontRepeatFor.new(300, "test/b") { results << :b }
      expect(results).to eq([:a, :b])
    end

    it "converts time to integer" do
      instance = DontRepeatFor.new(300.5, "test/float") {}
      expect(instance.time).to eq(300)
    end

    it "exposes key and time as accessors" do
      instance = DontRepeatFor.new(600, "test/accessors") {}
      expect(instance.key).to eq("test/accessors")
      expect(instance.time).to eq(600)
    end
  end

  describe "redis key format" do
    it "namespaces keys under DontRepeatFor/v1/Keys/" do
      DontRepeatFor.new(300, "my/custom/key") {}
      expected_key = "DontRepeatFor/v1/Keys/my/custom/key"
      expect(fake_redis.expirations).to have_key(expected_key)
    end
  end

  describe "expiry" do
    it "sets the expiry to the given time in seconds" do
      DontRepeatFor.new(600, "test/expiry") {}
      expected_key = "DontRepeatFor/v1/Keys/test/expiry"
      expect(fake_redis.expirations[expected_key]).to eq(600)
    end

    it "does not set expiry on duplicate calls" do
      DontRepeatFor.new(600, "test/expiry_once") {}
      fake_redis.expirations.clear
      DontRepeatFor.new(600, "test/expiry_once") {}
      expect(fake_redis.expirations).to be_empty
    end
  end

  describe "redis connection" do
    it "uses $redis global when defined" do
      executed = false
      DontRepeatFor.new(300, "test/global_redis") { executed = true }
      expect(executed).to be true
      expect(fake_redis.expirations).to have_key("DontRepeatFor/v1/Keys/test/global_redis")
    end
  end
end
