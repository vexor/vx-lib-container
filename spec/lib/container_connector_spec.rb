require 'spec_helper'

describe Vx::ContainerConnector do
  it { should be }

  context "lookup" do
    it "should return local connector" do
      expect(described_class.lookup(:local)).to be_an_instance_of(Vx::ContainerConnector::Local)
    end
  end
end
