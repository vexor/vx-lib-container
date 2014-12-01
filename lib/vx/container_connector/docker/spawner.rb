require 'vx/lib/spawn'

module Vx
  module ContainerConnector

    class Docker

      class Spawner

        include Vx::Lib::Spawn

        attr_reader :container, :user, :chdir

        def initialize(container, options)
          @container  = container
          @user       = options[:user]
          @chdir      = options[:chdir]
        end

        def spawn(command, options = {})
          options[:stdin] ||= StringIO.new("")
          options.merge!(pty: true)
          #pid = container.json['State']['Pid']

          #nsenter = "nsenter --target #{pid} -F --mount --uts --ipc --net --pid"
          #command = "#{nsenter} -- su '#{user} -c \"#{command}\"'"
          command = "docker exec -t #{container.id} env -i su #{user} -c 'cd #{chdir} ; #{command}'"

          super(command, options){|re| yield re }
        end

        def id
          container.id
        end

      end
    end
  end
end
