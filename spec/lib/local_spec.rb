require 'spec_helper'

describe Vx::ContainerConnector::Local do
  let(:conn) { described_class.new }
  subject { conn }

  it { should be }

  context "work_dir" do
    it "by default should be inside Dir.tmpdir" do
      expect(conn.work_dir).to eq("#{Dir.tmpdir}/.vx_local_connector")
    end

    it "when passed via options, should be" do
      expect(described_class.new(work_dir: "/tmp").work_dir).to eq '/tmp'
    end
  end

  context "start container" do

    it "spawner id should eq local" do
      rs = nil
      conn.start do |spawner|
        rs = spawner.id
      end
      expect(rs).to eq 'local'
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

        dir = "#{Dir.tmpdir}/.vx_local_connector\n"
        if RUBY_PLATFORM =~ /darwin/
          dir.gsub!(/^\/var/, '/private/var')
        end

        expect(rs).to eq dir
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

        expect(rs).to match(/No such file or directory/)
        expect([1,2]).to be_include(code)
      end
    end
  end

end
