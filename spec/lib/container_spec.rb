require 'spec_helper'

describe Vx::Lib::Container do
  it { should be }

  context "lookup" do
    it "should return local connector" do
      expect(described_class.lookup(:local)).to be_an_instance_of(Vx::Lib::Container::Local)
    end

    it "should return docker connector" do
      expect(described_class.lookup(:docker)).to be_an_instance_of(Vx::Lib::Container::Docker)
    end
  end
end
