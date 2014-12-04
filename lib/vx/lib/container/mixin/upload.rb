require 'base64'

module Vx ; module Lib ; module Container

  module Upload
    def upload(content, path, options = {})
      mode = options[:mode] || '0600'
      encoded = ::Base64.encode64(content).gsub("\n", '')
      "( echo #{encoded} | base64 --decode ) > #{path} ; chmod #{mode} #{path}"
    end
  end

end ; end ; end
