require 'spec_helper'

class TestRetriable
  include Vx::Lib::Container::Retriable

  class Error < Exception ; end
end

describe Vx::Lib::Container::Retriable do
  let(:proxy) { TestRetriable.new }

  it "should rescue 2 times" do
    expect(test_retriable(2)).to eq :pass
  end

  it "should fail on 3 attempt" do
    expect {
      test_retriable(3)
    }.to raise_error(TestRetriable::Error, "0")
  end

  def test_retriable(n)
    proxy.with_retries(TestRetriable::Error, limit: 3, sleep: 0.1) do
      if n != 0
        n -= 1
        raise TestRetriable::Error.new(n.to_s)
      end
      :pass
    end
  end

end
