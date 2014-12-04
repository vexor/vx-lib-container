require 'spec_helper'

describe Vx::Lib::Container::Docker do
  let(:conn) { described_class.new }

  it { should be }

  context "user" do
    subject { conn.user }

    it "by default should eq 'vexor'" do
      expect(subject).to eq 'vexor'
    end

    it "when passed via options should be" do
      expect(described_class.new(user: "user").user).to eq 'user'
    end
  end

  context "password" do
    subject { conn.password }

    it "by default should eq 'vexor'" do
      expect(subject).to eq 'vexor'
    end

    it "when passed via options should be" do
      expect(described_class.new(password: "pass").password).to eq 'pass'
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
      expect(subject).to eq ["/sbin/my_init"]
    end

    it "when passed via options should be" do
      expect(described_class.new(init: "init").init).to eq 'init'
    end
  end

  context "start container", docker: true do

    let(:conn) { described_class.new }

    it 'should be successfuly' do
      rs = nil
      conn.start do |sh|
        rs = sh.id
      end
      expect(rs).to_not be_empty
    end

    it 'should be successfuly with memory limit' do
      gb = 1024 * 1024 * 1024
      conn = described_class.new memory: gb, memory_swap: 2 * gb
      rs = nil
      conn.start do |sh|
        rs = sh.id
      end

      expect(rs).to_not be_empty
    end

    context "and spawn script" do
      it "successfuly" do
        rs   = ""
        code = nil

        conn.start do |sh|
          code = sh.exec("pwd") do |out|
            rs << out
          end
        end

        expect(rs).to eq "/home/vexor\r\n"
        expect(code).to eq 0
      end

      it "failed" do
        code = nil
        rs   = ""
        conn.start do |sh|
          code = sh.exec('ls /notexists ; exit') do |out|
            rs << out
          end
        end

        expect([1,2]).to be_include(code)
        expect(rs).to match(/No such file or directory/)
      end
    end
  end

end
