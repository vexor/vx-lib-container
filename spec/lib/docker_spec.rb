require 'spec_helper'

describe Vx::ContainerConnector::Docker do
  let(:conn) { described_class.new }

  it { should be }

  context "user" do
    subject { conn.user }

    it "by default should eq 'root'" do
      expect(subject).to eq 'root'
    end

    it "when passed via options should be" do
      expect(described_class.new(user: "user").user).to eq 'user'
    end
  end

  context "image" do
    subject { conn.image }

    it "when passed via options should be" do
      expect(described_class.new(image: "image").image).to eq 'image'
    end
  end

  context "init" do
    subject { conn.init }

    it "by default should be" do
      expect(subject).to eq "/sbin/init"
    end

    it "when passed via options should be" do
      expect(described_class.new(init: "init").init).to eq 'init'
    end
  end

  context "start container", docker: true do

    let(:conn) { described_class.new }

    it 'should be successfuly' do
      rs = nil
      conn.start do |spawner|
        rs = spawner.id
      end
      expect(rs).to_not be_empty
    end

    it 'should be successfuly with memory limit' do
      conn = described_class.new memory: 1024 * 1024 * 10, memory_swap: 1024 * 1024 * 20
      rs = nil
      conn.start do |spawner|
        rs = spawner.id
      end
      expect(rs).to_not be_empty
    end

    context "and spawn script" do
      it "successfuly" do
        rs   = ""
        code = nil

        conn.start do |spawner|
          code = spawner.spawn("echo $PWD") do |out|
            rs << out
          end
        end

        expect(rs).to eq "/\r\n"
        expect(code).to eq 0
      end

      it "failed" do
        code = nil
        rs   = ""
        conn.start do |spawner|
          code = spawner.spawn('ls /notexists') do |out|
            rs << out
          end
        end

        expect([1,2]).to be_include(code)
        expect(rs).to match(/No such file or directory/)
      end
    end
  end

end
